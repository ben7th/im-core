require "rails_helper"

describe Faq, :type => :model do
  before :each do
    @tag = Tag.create(name: "巨著")
    @reference = Reference.create(name: "红楼梦", describe: "文学巨著", kind: "文章", tags_name: [])
    @faq = Faq.create(:question=> "为什么 1+1=2 ?", :answer=> "一个加一个等于两个", :reference_ids=> [@reference.id], :tags_name => [@tag.name, "123456"])
  end

  it '创建 faq 成功' do
    expect(Faq.last.question).to eq("为什么 1+1=2 ?")
  end

  it "faq 修改" do
    faq_update = Faq.find(@faq.id)
    faq_update1 = faq_update.update(answer: "我怎么知道", :tags_name => [@tag.name])
    expect(Faq.last.answer).to eq("我怎么知道")
  end

  it "faq 与 tag 的关联" do
    faq = Faq.find(@faq.id)
    faq.update(:tags_name => [@tag.name, "123456"])
    expect(Faq.last.tags.count).to eq(2)
    expect(Tag.last.name).to eq("123456")
  end

  it "faq 与 reference 的关联" do
    reference = Reference.create(name: "西游记", describe: "文学巨著", kind: "文章", tags_name: [])
    faq = Faq.find(@faq.id)
    faq.update(:reference_ids=> [@reference.id, reference.id], :tags_name => [@tag.name])

    expect(Faq.last.references.count).to eq(2)
  end

  it "faq 删除" do
    faq_update = Faq.find(@faq.id).destroy
    expect(Faq.count).to eq(0)
  end
end