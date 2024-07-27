const base64String = "SGVsbG8sIFdvcmxkIQ==";
const decodedBuffer = Buffer.from(base64String, 'base64');
const decodedString = decodedBuffer.toString('utf-8');

console.log(`String codificada em Base64: ${base64String}`);
console.log(`Decodificado: ${decodedString}`);