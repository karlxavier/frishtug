import fileIcon from '../images/file-icon.svg'
document.addEventListener('DOMContentLoaded', ()=>{
  let dropzone = document.querySelector('.dropzone')
  let dropzoneFile = document.querySelector('.dropzone_file')

  const forEachPromise = (items, fn, context) => {
    return Array.from(items).reduce( (promise, item) => {
      return promise.then( () => {
        return fn(item)
      })
    }, Promise.resolve())
  }

  const spinnerShow = () => {
    dropzone.innerHTML = `<div class="sk-cube-grid">
      <div class="sk-cube sk-cube1"></div>
      <div class="sk-cube sk-cube2"></div>
      <div class="sk-cube sk-cube3"></div>
      <div class="sk-cube sk-cube4"></div>
      <div class="sk-cube sk-cube5"></div>
      <div class="sk-cube sk-cube6"></div>
      <div class="sk-cube sk-cube7"></div>
      <div class="sk-cube sk-cube8"></div>
      <div class="sk-cube sk-cube9"></div>
    </div>`
  }

  const spinnerHide = () => {
    dropzone.innerHTML = ''
  }

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

        reader.addEventListener('loadstart', function() {
          spinnerShow()
        })

        reader.addEventListener('load', function() {
          const img = new Image()
          img.src = this.result
          img.height = 100
          img.title = file.name
          img.className = 'rounded raised-1'
          div.appendChild(img)
        })

        reader.addEventListener('loadend', function() {
          spinnerHide()
          dropzone.appendChild(div)
        })

        reader.readAsDataURL(file)
      }
    }

    if (files) {
      [].forEach.call(files, readAndPreview)
    }
  }

  const readDocs = (files) => {
    const div = document.createElement('div')
    const textFile = 'text.*'
    div.className = 'dropzone_uploaded_files'

    const is_spreedsheet = (file) => {
      return /\.(csv|xls|xlsx|xlsm)$/i.test(file.name) 
    }

    const displayFileIcon = (file) => {
      if (file.type.match(textFile)) {
        const img = new Image()
        const p = document.createElement('p')
        const text = document.createTextNode(file.type)
        img.src = fileIcon
        img.height = 100
        img.title = file.name
        img.className = 'rounded raised-1'
        p.className = 'text-uppercase'
        p.appendChild(text)
        div.appendChild(img)
        div.appendChild(p)
        dropzone.innerHTML = '';
        dropzone.appendChild(div)
      }
    }

    if (files) {
      [].forEach.call(files, displayFileIcon)
    }

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
      readDocs(files)
      returnOriginalState()
    } else {
      console.warn('Please provide an input[type=file] with a class of dropzone_file')
      dropzone.className = 'dropzone has_an_error'
    }
  }

  const readFile = (e) => {
    readImage(e.target.files)
  }

  const init = () => {
    dropzone = document.querySelector('.dropzone')
    dropzoneFile = document.querySelector('.dropzone_file')
    if (dropzone) {
      dropzone.addEventListener('dragover', dragover)
      dropzone.addEventListener('dragleave', dragleave)
      dropzone.addEventListener('drop', drop)
      dropzoneFile.addEventListener('change', readFile)
    }
  }

  if (dropzone) {
    init()
  } else {
    console.warn('There is no dropzone class found!')
  }

  window.dropzone_init = init
})