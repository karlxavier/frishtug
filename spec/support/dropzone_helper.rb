module DropzoneHelper
  def drop_in_dropzone(file_path, dummy_container)
    execute_script <<-JS
      dummyFileInput = document.createElement('input');
      dummyFileInput.type = 'file';
      dummyFileInput.id = 'dummy-file-input';
      document.querySelector(#{dummy_container}).appendChild(dummyFileInput)
    JS
    attach_file 'dummy-file-input', file_path
    execute_script <<-JS
      var e = jQuery.Event('drop', { dataTransfer : { files: [dummyFileInput.get(0).files[0]]}});
      $('.dropzone')[0].dropzone.listeners[0].events.drop(e)
    JS
  end
end