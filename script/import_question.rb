p '开始导入题'
Question.destroy_all
p "先清数据库Question"

def randstr(length=8)
  base = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  size = base.size
  re = '' << base[rand(size-10)]
  (length - 1).times {
    re << base[rand(size)]
  }
  re
end

def import_a_file(link)
  json_atr = IO.read( link )
  question_hash = JSON.parse(json_atr)
  questions = question_hash['question']


  questions.each do |question|
    create_params={}

    case question["kind"]
    when "multi_choice" ,"single_choice"
      item_id_hash = {}
      params_answer = []

      params_answer_choices = question["answer"]["choices"].map do |item|
        rand_str = randstr
        item_id_hash[item["item"]] = rand_str
        {"id": rand_str, "text": item["text"]}
      end

      if  question["kind"] == "multi_choice"
        params_answer_corrects =  question["answer"]["corrects"].map{|x| item_id_hash[x]}
        params_answer = {"choices": params_answer_choices ,"corrects": params_answer_corrects}
      else
        params_answer_correct = item_id_hash[question["answer"]["correct"]]
        params_answer = {"choices": params_answer_choices ,"correct": params_answer_correct} 
      end
      Question.create(:kind=>question["kind"],:content=>question["content"],:answer=>params_answer)

    when "bool"
      Question.create(question)
    end
  end

end

links = Dir["./import_data/*.yaml"]
links.each do |x|
  import_a_file(x)
end

