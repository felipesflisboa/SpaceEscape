BEST_SCORE_KEY = "Best"
LAST_SCORE_KEY = "Last"

getScore = (key) -> cc.sys.localStorage.getItem(key) ? 0
setScore = (key, score) -> cc.sys.localStorage.setItem(key, score.toString())

module.exports.getBestScore = () -> getScore(BEST_SCORE_KEY)
module.exports.setBestScore = (score) -> setScore(BEST_SCORE_KEY, score)
module.exports.getLastScore = () -> getScore(LAST_SCORE_KEY)
module.exports.setLastScore = (score) -> setScore(LAST_SCORE_KEY, score)