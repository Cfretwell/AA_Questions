require_relative 'questions_database.rb'

class Reply

    attr_accessor :id, :body, :subject_question, :parent_reply, :user_id

    def initialize(options)
        @id     = options["id"]
        @body = options["body"]
        @subject_question = options["subject_question"]
        @parent_reply = options["parent_reply"]
        @user_id = options["user_id"]
    end


    def child_replies()
        result = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT 
                *
            FROM 
                replies
            WHERE
                parent_reply = ?;
        SQL

        result.map! {|q| Reply.new(q) }
        return result
    end

    def get_parent_reply()
        result = QuestionsDatabase.instance.execute(<<-SQL, @parent_reply)
            SELECT 
                *
            FROM 
                replies
            WHERE
                id = ?;
        SQL
        return Reply.new(result[0]) 
    end

    def author()
        result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT 
                *
            FROM 
                users
            WHERE
                id = ?;
        SQL

        User.new(result[0])
    end

    def question()
        result = QuestionsDatabase.instance.execute(<<-SQL, subject_question)
            SELECT 
                *
            FROM 
                questions
            WHERE
                id = ?;
        SQL

        Question.new(result[0])

    end

    def self.find_by_question_id(subject_question)
        result = QuestionsDatabase.instance.execute(<<-SQL, subject_question)
            SELECT 
                *
            FROM 
                replies
            WHERE
                subject_question = ?;
        SQL

        result.map! {|q| Reply.new(q) }
        return result
    end

    def self.find_by_user_id(in_user_id)
        result = QuestionsDatabase.instance.execute(<<-SQL, in_user_id)
            SELECT 
                *
            FROM 
                replies
            WHERE
                user_id = ?;
        SQL

        result.map! {|q| Reply.new(q) }
        return result
    end

    def self.find_by_id(id)

        result = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT 
                *
            FROM 
                replies
            WHERE
                id = ?;
        SQL

        if result.length ==1 
            return Reply.new(result[0])
        else 
            puts "resluts not found"
        end

    end


    def save()
        
        if self.id
            update()
        else 
            create()
        end
    end

    private 

    def create()

        QuestionsDatabase.instance.execute(<<-SQL, body, subject_question, parent_reply, user_id)
            INSERT INTO
                replies (body, subject_question, parent_reply, user_id)
            VALUES
                (?,?,?,?)
        SQL

        puts "New Record Created!"
        self.id = QuestionsDatabase.instance.last_insert_row_id
    end

    def update()
        
        QuestionsDatabase.instance.execute(<<-SQL,self.body, self.subject_question, self.parent_reply, self.user_id, self.id)
            UPDATE
                replies
            SET
                body =?, subject_question=?, parent_reply=?, user_id = ?
            WHERE
                id = ?
        SQL
       
        puts "Record Updated!"
    end
end