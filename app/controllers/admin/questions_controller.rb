class Admin::QuestionsController < ApplicationController
  def index
    @component_name = "QuestionIndexPage"
    @component_data = {
      questions: Question.all.map{ |question|
        question.controller_data
      },
      single_new_url: new_admin_question_path,
      multi_new_url: multi_new_admin_questions_path,
      bool_new_url: bool_new_admin_questions_path,
    }
  end

  def new 
    question = Question.new
    choice_count = 0
    @component_name = "SingleEditPage"
    @component_data = {
      questions: question.single_controller_data,
      submit_url: admin_questions_path,
      cancel_url: admin_questions_path,
      choice_count: 4,
    }
  end

  def multi_new
    question = Question.new
    @component_name = "MultiEditPage"
    @component_data = {
      questions: question.single_controller_data,
      submit_url: admin_questions_path,
      cancel_url: admin_questions_path,
      choice_count: 4,
    }
  end

  def bool_new
    question = Question.new
    @component_name = "BoolEditPage"
    @component_data = {
      questions: question.bool_controller_data,
      submit_url: admin_questions_path,
      cancel_url: admin_questions_path,
    }
  end

  def create
    if params[:json_string] == nil
      question = Question.new(question_params)
      set_bool_answer(question)
    else
      data = JSON.parse params[:json_string]
      question = Question.new(content: data["Questions[content]"], kind: data["Questions[kind]"], answer: data["Questions[answer]"])
    end
    
    if question.save
      redirect_to admin_questions_path
    else
      render json: "创建题目失败"
    end
  end

  def edit
    question = Question.find(params[:id])
    @component_name = ''
    choice_count = 0
    if question.kind == "single_choice"
      @component_name = "SingleEditPage"
      choice_count = question.answer["choices"].length
    end

    if question.kind == "multi_choice"
      @component_name = "MultiEditPage"
      choice_count = question.answer["choices"].length
    end

    if question.kind == "bool"
      @component_name = "BoolEditPage"
    end

    @component_data = {
      questions: question.controller_data,
      submit_url: admin_question_path(question),
      cancel_url: admin_questions_path,
      choice_count: choice_count
    }
  end

 def update
    question = Question.find(params[:id])
    if params[:json_string] == nil
      question.update(question_params)
      set_bool_answer(question)
    else
      data = JSON.parse params[:json_string]
      question.update(content: data["Questions[content]"], kind: data["Questions[kind]"], answer: data["Questions[answer]"])
    end

    if question.save
      redirect_to admin_questions_path
    else
      render json: "更新题目失败"
    end
  end

  def destroy
    question = Question.find(params[:id])
    question.destroy
    redirect_to admin_questions_path
  end

  private
    def set_bool_answer(question)
      if question.answer == "false" || question.answer == "true"
        if question.answer ==  "false"
           question.answer = false
         else
          question.answer = true
         end 
      end
    end

    def question_params
      params.require(:Questions).permit(:content, :kind, :answer)
    end
end