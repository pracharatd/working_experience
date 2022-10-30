import qrcode

img = qrcode.make('https://www.pttngd.co.th/upload_approved/she/20220909151035_SDSNGPTTNGD2.pdf')

type(img)  # qrcode.image.pil.PilImage

img.save("MSDS_QRCode.png")
