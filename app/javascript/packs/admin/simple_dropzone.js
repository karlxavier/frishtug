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

    returnOriginalState()
    return false;
  }

  const returnOriginalState = () => {
    dropzone.className = 'dropzone'
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

  const readImage = (files) => {
    const div = document.createElement('div')
    div.className = 'dropzone_uploaded_files'

    const readAndPreview = (file) => {
      if( /\.(jpe?g|png|gif)$/i.test(file.name) ) {
        const reader = new FileReader()
        reader.addEventListener('load', function() {
          const img = new Image()
          img.src = this.result
          img.height = 100
          img.title = file.name
          img.className = 'rounded shadow'
          div.appendChild(img)
        })

        reader.readAsDataURL(file)
      }
    }

    if (files) {
      [].forEach.call(files, readAndPreview)
    }
    dropzone.innerHTML = ''
    dropzone.appendChild(div)
  }

  const drop = (e) =>{
    e.preventDefault()
    e.stopPropagation();
    let files = e.dataTransfer.files
    let isSingleFile = files.length > 1 && dropzoneFile.classList.contains('single_file')
    let onlyImage = dropzoneFile.classList.contains('only_image')

    if (onlyImage) {
      if (!isImage(files)) {
        returnOriginalState()
        dropzoneFile.files = null
        return false
      }
    }

    if (isSingleFile) {
      alert('You can only upload 1 image file');
      returnOriginalState();
      return false;
    }


    if (dropzoneFile) {
      dropzoneFile.files = files
      readImage(files)
      returnOriginalState()
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