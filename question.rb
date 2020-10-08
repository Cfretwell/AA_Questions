require_relative 'questions_database.rb'

class Question

    attr_accessor :id, :title, :body, :author

    def initialize(options)
        @id     = options["id"]
        @title  = options["title"]
        @body   = options["body"]
        @author = options["author"]
        
    end

    def self.most_liked(n)
        QuestionLikes.most_liked_questions(n)
    end

    def likers()
        QuestionLikes.likers_for_quesiton_id(id)
    end

    def num_likes()
        QuestionLikes.num_likes_for_question_id(id)
    end

    def self.most_followed(n)
        QuestionFollow.most_followed_questions(n)
    end

    def followers()
        QuestionFollow.followers_for_question_id(id)
    end

    def get_author()
        result = QuestionsDatabase.instance.execute(<<-SQL, @author)
            SELECT 
                *
            FROM 
                users
            WHERE
                id = ?;
        SQL

        User.new(result[0])
    end

    def replies()
        Reply.find_by_question_id(id)
    end

    def self.find_by_author_id(author_id)
        result = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT 
                *
            FROM 
                questions
            WHERE
                author = ?;
        SQL
        
        result.map! {|q| Question.new(q) }
        return result
    end


    def self.find_by_id(id)

        q_result = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT 
                *
            FROM 
                questions
            WHERE
                id = ?;
        SQL

        if q_result.length ==1 
            return Question.new(q_result[0])
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
        QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.author)
        INSERT INTO
            questions (title, body, author)
        VALUES
            (?, ?, ?)
        SQL
        puts "New Record Created!"
        self.id = QuestionsDatabase.instance.last_insert_row_id
    end

    def update()
        QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.author, self.id)
            UPDATE
                quesitons
            SET
                title =?, body=?, author=?
            WHERE
                id = ?
        SQL
        puts "Record Updated!"
    end
end