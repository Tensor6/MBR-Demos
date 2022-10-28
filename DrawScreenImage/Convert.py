from PIL import Image

image = Image.open("scaled_indexed.bmp")
pixels = image.load()

w = image.width
h = image.height

out_file = open("image.bin", "wb")

bytesWritten = 0

for y in range(h):
    for x in range(w):
        bytesWritten += out_file.write(int.to_bytes(pixels[x,y], 1, 'little'))


out_file.close()
print(f"{bytesWritten} bytes written!")