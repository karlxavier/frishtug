document.addEventListener('turbolinks:load', ()=>{
  var dropzone = document.querySelector('.dropzone')
  var dropzoneFile = document.querySelector('.dropzone_file')

  const dragover = (e) => {
    e.stopPropagation();
    e.preventDefault();

    dropzone.className = 'dropzone is_dragging'
    return false;
  }

  const dragleave = (e) =>{
    e.stopPropagation();
    e.preventDefault();

    dropzone.className = 'dropzone'
    return false;
  }

  const isImage = (file) => {
    for (let i = 0; i <= file.length-1; i++) {
      let mimeType = file[i].type
      if (mimeType.split('/')[0] !== 'image') {
        alert('Expecting an image file')
        console.warn(`Expected an image but got a file with type of ${file[0].type}`)
        return false
      }
    }
    return true
  }

  const drop = (e) =>{
    e.preventDefault()
    e.stopPropagation();
    let files = e.dataTransfer.files
    let isSingleFile = files.length > 1 && dropzoneFile.classList.contains('single_file')
    let onlyImage = dropzoneFile.classList.contains('only_image')

    if (onlyImage) {
      if (!isImage(files)) {
        return false
      }
    }

    if (isSingleFile) {
      alert('You can only upload 1 image file');
      return false;
    }


    if (dropzoneFile) {
      dropzoneFile.files = files
      dropzone.className = 'dropzone'
    } else {
      console.warn('Please provide an input[type=file] with a class of dropzone_file')
      dropzone.className = 'dropzone has_an_error'
    }
  }

  if (dropzone) {
    dropzone.addEventListener('dragover', dragover)
    dropzone.addEventListener('dragleave', dragleave)
    dropzone.addEventListener('drop', drop)
  } else {
    console.warn('There is no dropzone class found!')
  }
})