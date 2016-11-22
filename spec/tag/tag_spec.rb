require "rails_helper"

describe Reference, :type => :model do
  before :each do
    @reference = Reference.create(name: "红楼梦", describe: "文学巨著", kind: "文章", tags_name: ["巨著"])
    @reference_one = Reference.create(name: "西游记", describe: "文学巨著", kind: "文章", tags_name: ["巨著"])
    @reference_two = Reference.create(name: "水浒传", describe: "文学巨著", kind: "文章", tags_name: ["巨著"])
    @faq = Faq.create(:question=> "为什么 1+1=2 ?", :answer=> "一个加一个等于两个", :reference_ids=> [@reference.id], :tags_name => ["123456"])
    @faq_one = Faq.create(:question=> "为什么会下雪", :answer=> "不知道", :reference_ids=> [@reference.id], :tags_name => ["123456"])
    @faq_two = Faq.create(:question=> "乌龟有几条腿", :answer=> "四条", :reference_ids=> [@reference.id], :tags_name => ["123456"])

  end

  it '创建 tag 成功' do
    expect(Tag.first.name).to eq("巨著")
    expect(Tag.last.name).to eq("123456")
    expect(Tag.count).to eq(2)
  end

  it "tag 修改" do
    tag = Tag.where(name: "巨著").first
    tag.update(name: "文学作品")
    expect(Tag.find(tag.id).name).to eq("文学作品")
  end

  it "tag 与 reference 和 faq 的关联" do
    tag = Tag.where(name: "巨著").first
    tag_one = Tag.where(name: "123456").first

    name_ary = []
    name_ary_one = []
    tag.refs.each do |t|
      name_ary.push(t.name)
    end

    tag_one.faqs.each do |f|
      name_ary_one.push(f.question)
    end

    expect(tag.refs.length).to eq(3)
    expect(name_ary).to eq(["红楼梦","西游记","水浒传"])
    expect(tag_one.faqs.length).to eq(3)
    expect(name_ary_one).to eq(["为什么 1+1=2 ?","为什么会下雪","乌龟有几条腿"])
  end

  it "tag 中 change_faqs 方法" do
    faq = Faq.create(:question=> "三国演义作者是谁？", :answer=> "罗贯中", :reference_ids=> [@reference.id], :tags_name => [])

    tag = Tag.where(name: "123456").first
    # 往 TAG 中加了一个值为 “三国演义作者是谁？”的 faq
    tag.change_faqs([faq.id.to_s])
    expect(tag.faqs.length).to eq(1)

    # 从 TAG 中减一个值
    tag.change_faqs([])
    expect(tag.faqs.length).to eq(0)

    # 先预支两个 faq 然后从 TAG 中删除一个和加一个 这两个 faq之外的 faq
    tag.change_faqs([@faq.id.to_s, @faq_one.id.to_s])
    tag.change_faqs([@faq.id.to_s, faq.id.to_s])
    expect(tag.faqs.length).to eq(2)
    expect(tag.faqs[0].question).to eq(@faq.question)
    expect(tag.faqs[1].question).to eq(faq.question)
  end

  it "tag 中 change_refs 方法" do
    reference = Reference.create(name: "三国演义", describe: "文学巨著", kind: "文章", tags_name: ["巨著"])

    tag = Tag.where(name: "巨著").first
    # 往 TAG 中加了一个值为 “三国演义”的 reference
    tag.change_refs([reference.id.to_s])
    expect(tag.refs.length).to eq(1)

    # 从 TAG 中减一个值
    tag.change_refs([])
    expect(tag.refs.length).to eq(0)

    # 先预支两个 reference 然后从 TAG 中删除一个和加一个 这两个 reference 之外的 reference
    tag.change_refs([@reference.id.to_s, @reference_one.id.to_s])
    tag.change_refs([@reference.id.to_s, reference.id.to_s])
    expect(tag.refs.length).to eq(2)
    expect(tag.refs[0].name).to eq(@reference.name)
    expect(tag.refs[1].name).to eq(reference.name)
  end

  it "tag 删除" do
    before_delete_count = Tag.count
    tag = Tag.where(name: "巨著").first
    tag_id = tag.id
    Tag.find(tag_id).destroy
    expect(Tag.count).to eq(before_delete_count - 1)

    refs = tag.refs
    faqs = tag.faqs
    refs.each do |r|
      expect(r.tag_ids.include?(tag_id)).to eq(false)
    end
    faqs.each do |f|
      expect(f.tag_ids.include?(tag_id)).to eq(false)
    end
  end
end