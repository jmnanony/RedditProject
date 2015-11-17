import praw
r = praw.Reddit('Getting from subreddit 01')

#subreddits = ["all"]
subreddits = ["BlackPeopleTwitter", "pics", "me_irl", "funny", "videos", "gifs", "4chan", "todayilearned", "worldnews", "WTF", "aww", "technology", "Showerthoughts"]
for subred in subreddits:

    submissions = r.get_subreddit(subred).get_top_from_year(limit=1000)
    filename = "YearTop-" + subred + ".txt"

    f = open(filename, 'w')
    f.write("fullname\tcreated_utc\tscore\tdomain\tsubreddit\ttitle\n")

    for submission in submissions:
        fullname = str(submission.fullname)
        created_utc = str(submission.created_utc)
        domain = str(submission.domain)
        score = str(submission.score)
        subreddit = str(submission.subreddit)
        title = str(submission.title)
        try :
            f.write(fullname + "\t" + created_utc + "\t" + score + "\t" + domain + "\t" + subreddit + "\t" + title + "\n")
        except :
            pass

    f.close()






