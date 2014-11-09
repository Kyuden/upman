class Item < ActiveRecord::Base
  acts_as_copy_target

  def self.to_csv
    CSV.generate(headers: column_names, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv << row.attributes.values_at(*column_names).map{|v| v.to_s.encode('utf-8', 'binary', invalid: :replace, undef: :replace, replace: '')}
      end
    end
  end

  def self.import_csv(csv_file)
    csv_text = csv_file.read

    CSV.parse(Kconv.toutf8(csv_text)) do |row|

    user = Item.new(row[0] )
    user.name         =  #csvの1列目を格納
    user.created_at   = row[1]  #csvの2列目を格納
    user.updated_at = row[2]  #csvの3列目を格納
    user.image     = row[3]  #csvの4列目を格納
    user.image_content_type = row[2]  #csvの3列目を格納

    user.save
  end
  end
end
