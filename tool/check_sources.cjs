const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
function walk(dir) { return fs.readdirSync(dir, { withFileTypes: true }).flatMap(e => e.isDirectory() ? walk(path.join(dir, e.name)) : [path.join(dir, e.name)]); }
let failures = 0;
for (const file of walk(path.join(root, 'lib')).filter(f => f.endsWith('.dart'))) {
  const source = fs.readFileSync(file, 'utf8');
  const tokens = source.replace(/\/\*[\s\S]*?\*\//g, '').replace(/\/\/[^\n]*/g, '').replace(/'(?:\\.|[^'\\])*'|"(?:\\.|[^"\\])*"/g, '');
  const stack = [];
  for (let i = 0; i < tokens.length; i++) {
    const c = tokens[i];
    if ('([{'.includes(c)) stack.push(c);
    if (')]}'.includes(c) && stack.pop() !== { ')': '(', ']': '[', '}': '{' }[c]) { console.error('Unbalanced delimiters:', path.relative(root, file)); failures++; break; }
  }
  if (stack.length) { console.error('Unclosed delimiters:', path.relative(root, file)); failures++; }
  for (const match of source.matchAll(/['"](assets\/images\/[^'"$]+)['"]/g)) {
    if (!fs.existsSync(path.join(root, match[1]))) { console.error('Missing asset:', match[1]); failures++; }
  }
  for (const match of source.matchAll(/import ['"]([^'"]+)['"]/g)) {
    if (!match[1].startsWith('package:') && !match[1].startsWith('dart:') && !fs.existsSync(path.resolve(path.dirname(file), match[1]))) { console.error('Missing import:', match[1]); failures++; }
  }
}
if (failures) process.exitCode = 1;
else console.log('Local Dart imports, literal asset paths and delimiter checks passed. This does not replace Flutter analysis or widget tests.');
