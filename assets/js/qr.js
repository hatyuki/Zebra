var qr;

function QRCode ( )
{
    this.initialize( );
    qr = this;
}

QRCode.prototype = {
    scale: 4, // 拡大表示 (整数倍のみ)

    initialize: function ( ) {
        this.setupEvent( );
    },

    setupEvent: function ( ) {
        $('#text').on('keyup change', function ( ) {
            var text = $('#text').val( );

            if (text.length == 0) {
                $('#download').addClass('disabled').removeClass('btn-primary');
            }
            else {
                $('#download').removeClass('disabled').addClass('btn-primary');
            }

            $.ajax( {
                url: $(this).attr('data-generator'),
                type: 'POST',
                data: { text: text },
                dataType: 'json',
                timeout: 3000,
                success: function (res) {
                    qr.drawQRCode(res);
                },
                error: function ( ) {
                    console.log('Error!');
                }
            } );

            return false;
        } );

        $('#download').on('click', function ( ) {
            if ( $(this).hasClass('disabled') ) {
                return false;
            }

            var canvas = $('#qrcode').get(0);
            var image  = canvas.toDataURL('image/png');
            image = image.replace('image/png', 'image/octet-stream');
            $(this).attr('href', image);
        } );
    },

    drawQRCode: function (data) {
        var scale    = qr.scale;
        var datasize = data.length;
        var canvsize = datasize * scale;
        var canvas   = $('#qrcode').attr( { height: canvsize, width: canvsize } ).get(0).getContext('2d');
        var image    = canvas.createImageData(canvsize, canvsize);

        for (var y = 0 ; y < datasize ; y++) {
            for (var x = 0 ; x < datasize ; x++) {
                for (var sy = 0 ; sy < scale ; sy++) {
                    for (var sx = 0 ; sx < scale ; sx++) {
                        var index = (((x * scale) + sx) + (y * scale * canvsize + (sy * canvsize))) * 4;

                        if (data[y][x] == '*') { // Black
                            image.data[index + 0] =   0; // r
                            image.data[index + 1] =   0; // g
                            image.data[index + 2] =   0; // b
                            image.data[index + 3] = 255; // a
                        } else { // White
                            image.data[index + 0] = 255; // r
                            image.data[index + 1] = 255; // g
                            image.data[index + 2] = 255; // b
                            image.data[index + 3] = 255; // a
                        }
                    }
                }
            }
        }

        canvas.putImageData(image, 0, 0);
    }
};
