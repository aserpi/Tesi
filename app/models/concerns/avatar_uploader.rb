# Resize and upload an avatar.
class AvatarUploader < Shrine
  process(:store) do |io, _context|
    small = ImageProcessing::MiniMagick.resize_and_pad!(io.download, 23, 23, background: 'transparent',
                                                                               gravity: 'Center')
    medium = ImageProcessing::MiniMagick.resize_and_pad!(io.download, 500, 500, background: 'transparent',
                                                                                gravity: 'Center')

    { original: io, small: small, medium: medium }
  end
end
