module GreekLit
  def self.root_dir
    data_path = File.join(File.dirname(__FILE__), "../..")
  end
  def self.canonical_greek_lit_data
    "#{root_dir}/canonical-greekLit/data"
  end
end
