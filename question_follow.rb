require_relative 'questions_database.rb'

class QuestionFollow

    attr_accessor :id, :user_id, :question_id

    def initialize(options)
        @id     = options["id"]
        @user_id   = options["user_id"]
        @question_id  = options["question_id"]
    end

    def self.most_followed_questions(n)
        result = QuestionsDatabase.instance.execute(<<-SQL, n)
            SELECT 
                questions.id, questions.title, questions.body, questions.author, count(*)
            FROM 
                questions
            JOIN
                question_follows ON question_id = questions.id
            GROUP BY 
                questions.id
            ORDER BY 
                count(*) DESC
            LIMIT 
                ?
                
        SQL 

        result.map! {|q| Question.new(q)}

        return result 
    end

    def self.followed_questions_for_user_id(in_user_id)
        result = QuestionsDatabase.instance.execute(<<-SQL, in_user_id)
            SELECT 
                questions.id, questions.title, questions.body, questions.author
            FROM 
                questions
            JOIN
                question_follows ON question_id = questions.id
            WHERE
                user_id = ?;
        SQL

        result.map! {|q| Question.new(q)}

        return result 


    end

    def self.followers_for_question_id(in_question_id)

        result = QuestionsDatabase.instance.execute(<<-SQL, in_question_id)
            SELECT 
                users.id, users.fname, users.lname
            FROM 
                users
            JOIN
                question_follows ON user_id = users.id
            WHERE
                question_id = ?;
        SQL

        result.map! {|qf| User.new(qf)}

        return result 

    end

    def self.find_by_id(id)

        result = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT 
                *
            FROM 
                question_follows
            WHERE
                id = ?;
        SQL

        if result.length ==1 
            return QuestionFollow.new(result[0])
        else 
            puts "resluts not found"
        end

    end
end