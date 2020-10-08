require_relative 'questions_database.rb'

class User

    attr_accessor :id, :fname, :lname

    def initialize(options)
        @id     = options["id"]
        @fname  = options["fname"]
        @lname   = options["lname"]
    end

    def average_karma()
        result = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT 
                 (CAST(COUNT(question_id) as FLOAT) / COUNT(DISTINCT (questions.id)) ) as 'AverageKarma'
            FROM 
                questions
            LEFT JOIN
                question_likes ON questions.id = question_id
            WHERE
                author = ?
                
        SQL
        return result[0]["AverageKarma"]

    end

    def liked_questions()
        QuestionLikes.liked_questions_for_user_id(id)
    end

    def followed_questions()
        QuestionFollow.followed_questions_for_user_id(id)
    end

    def authored_questions()
        Question.find_by_author_id(id)
    end

    def authored_replies()
        Reply.find_by_user_id(id)
    end

    def self.find_by_name(fname, lname)
        result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT 
                *
            FROM 
                users
            WHERE
                fname = ? AND lname = ?;
        SQL

        if result.length ==1 
            return User.new(result[0])
        else 
            puts "resluts not found"
        end
    end

    def self.find_by_id(id)

        result = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT 
                *
            FROM 
                users
            WHERE
                id = ?;
        SQL

        if result.length ==1 
            return User.new(result[0])
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
        QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
        INSERT INTO
            users (fname, lname)
        VALUES
            (?, ?)
        SQL
        puts "New Record Created!"
        self.id = QuestionsDatabase.instance.last_insert_row_id
    end

    def update()
        QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname, self.id)
            UPDATE
                users
            SET
                fname = ?, lname = ?
            WHERE
                id = ?
        SQL
        puts "Record Updated!"
    end

end