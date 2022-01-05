
document.addEventListener('DOMContentLoaded', () => {
  initInputPictureSizeCheck()
})

function initInputPictureSizeCheck() {
  const micropostPictureInput = document.querySelector('#micropost_picture')

  micropostPictureInput?.addEventListener('change', (e) => {
    const input = e.target
    const file = input.files.item(0)

    if (!file) {
      return
    }

    const sizeInMb = file.size / 1024 / 1024
    
    if (sizeInMb > 5) {
      const dt = new DataTransfer()
      input.files = dt.files

      alert('Maximum file size is 5MB. Please choose a smaller file.')
    }
  })
}
