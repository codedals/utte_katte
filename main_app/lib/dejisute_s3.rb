module DejiSuteS3
  def self.delete(options = {})
    fname = options[:file_name]
    return false if fname.blank?
    begin
      bucket = S3_CONN.buckets.find(AWS_BUCKET)
      object = bucket.objects.find(fname)
      #RAILS_DEFAULT_LOGGER.debug "DELETING #{AWS_BUCKET}/#{fname}"
      object.destroy
    rescue
      #RAILS_DEFAULT_LOGGER.error "ERROR deleting #{AWS_BUCKET}/#{fname}"
      return false
    end
  end

  # Upload file to Amazon AWS bucket and return filename if successful, otherwise return false
  def self.upload(options = {})
    file_path = options[:file_path]
    fname = options[:file_name]
    if !File.exists?(file_path)
      #RAILS_DEFAULT_LOGGER.error "ERROR uploading #{file_path} to #{AWS_BUCKET_NAME}/#{fname} - FILE DOES NOT EXIST"
      return false
    end
    # grab extension from file
    ext = File.extname(file_path)
    unless fname
      t = Time.now
      fname = "#{t.to_i}#{t.usec}#{ext}"  # default filename to timestamp if not specified
    end
    begin
      #RAILS_DEFAULT_LOGGER.debug "SENDING #{fname} to #{AWS_BUCKET_NAME}"
      
      bucket = S3_CONN.buckets.find(AWS_BUCKET)
      new_object = bucket.objects.build(AWS_UPLOAD_DIR + "/" + fname)
      if new_object.exists?
        #RAILS_DEFAULT_LOGGER.error "ERROR uploading #{file_path} to #{AWS_BUCKET_NAME}/#{fname} - FILE ALREADY EXISTS"
        return false
      end
      # TODO - find better way to set proper mime type
      new_object.content_type = self.get_mime_type(fname)
      new_object.content = open(file_path)
      ret_val = new_object.save
    rescue
      #RAILS_DEFAULT_LOGGER.error "ERROR uploading #{file_path} to #{AWS_BUCKET_NAME}/#{fname}"
      return false
    end
    return fname if ret_val
  end

  # Quick and dirty way to determine expected mime types
  def self.get_mime_type(fname)
    if fname.include?(".jpg") or fname.include?(".jpeg")
      return "image/jpeg"
    elsif fname.include?(".gif")
      return "image/gif"
    elsif fname.include?(".png")
      return "image/png"
    elsif fname.include?(".txt")
      return "text/plain"
    else
      return "application/octet-stream"
    end
  end
end
