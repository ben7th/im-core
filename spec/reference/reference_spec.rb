require "rails_helper"

describe Reference, :type => :model do
  before :each do
    @reference = Reference.create(name: "红楼梦", describe: "文学巨著", kind: "文章", tags_name: ["巨著"])
  end

  it '创建 reference 成功' do
    expect(Reference.last.name).to eq("红楼梦")
  end

  it "reference 修改" do
    ref = Reference.find(@reference.id)
    ref_update = ref.update(describe: "伟大的红学", :tags_name => ["巨著"])
    expect(Reference.last.describe).to eq("伟大的红学")
  end

  it "reference 与 tag 的关联" do
    reference = Reference.find(@reference.id)
    reference.update(:tags_name => ["巨著", "59448484848"])
    expect(Reference.last.tags.count).to eq(2)
    expect(Tag.last.name).to eq("59448484848")
  end

  it "reference 删除" do
    ref = Reference.find(@reference.id).destroy
    expect(Reference.count).to eq(0)
  end
end