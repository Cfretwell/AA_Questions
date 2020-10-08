require_relative 'questions_database.rb'

class QuestionLike

    attr_accessor :id, :question_id, :user_id

    def initialize(options)
        @id     = options["id"]
        @question_id = options["question_id"]
        @user_id = options["user_id"]
    end

    def self.most_liked_questions(n)
        result = QuestionsDatabase.instance.execute(<<-SQL, n)
            SELECT 
                questions.id, questions.title, questions.body, questions.author, count(question_id)
            FROM 
                questions
            LEFT JOIN
                question_likes on questions.id = question_id
            GROUP BY 
                questions.id 
            ORDER BY 
                count(question_id) DESC
            LIMIT ? 
        SQL

        p result

        result.map! {|q| Question.new(q)}
        return result 
    end

    def self.liked_questions_for_user_id(in_user_id)
        result = QuestionsDatabase.instance.execute(<<-SQL, in_user_id)
            SELECT 
                questions.id, questions.title, questions.body, questions.author
            FROM 
                questions
            JOIN
                question_likes on questions.id = question_id
            WHERE
                user_id = ?;
        SQL

        result.map! {|q| Question.new(q)}
        return result 

    end

    def self.num_likes_for_question_id(in_question_id)
        result = QuestionsDatabase.instance.execute(<<-SQL, in_question_id)
            SELECT 
                count(*)
            FROM 
                users
            JOIN
                question_likes on users.id = user_id
            WHERE
                question_id = ?;
        SQL

        return result[0]["count(*)"]
    end

    def self.likers_for_question_id(in_question_id)
        result = QuestionsDatabase.instance.execute(<<-SQL, in_question_id)
            SELECT 
                DISTINCT users.id, fname, lname
            FROM 
                users
            JOIN
                question_likes on users.id = user_id
            WHERE
                question_id = ?;
        SQL

        result.map! {|ql| User.new(ql)}
        return result

    end


    def self.find_by_id(id)

        result = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT 
                *
            FROM 
                question_likes
            WHERE
                id = ?;
        SQL

        if result.length ==1 
            return QuestionLike.new(result[0])
        else 
            puts "resluts not found"
        end

    end
end