package com.easyoj.web.service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.TypeReference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.easyoj.web.mapper.ContestContestantMapper;
import com.easyoj.web.mapper.ContestMapper;
import com.easyoj.web.mapper.ContestSubmissionMapper;
import com.easyoj.web.mapper.ProblemMapper;
import com.easyoj.web.mapper.SubmissionMapper;
import com.easyoj.web.model.*;
import com.easyoj.web.util.SlugifyUtils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 竞赛(Contest)的业务逻辑层.
 * @author Haitao Wang
 */
@Service
@Transactional
public class ContestService {
	
	/**
	 * 获取竞赛列表.
	 * @param keyword - 竞赛的关键词
	 * @param offset - 起始竞赛的游标
	 * @param limit - 获取竞赛的数量
	 * @return 包含Contest的List对象
	 */
	public List<Contest> getContests(String keyword, long offset, int limit) {
		return contestMapper.getContests(keyword, offset, limit);
	}
	
	/**
	 * [此方法仅供管理员使用]
	 * 获取竞赛总数
	 * @param keyword - 竞赛的关键词
	 * @return
	 */
	public long getNumberOfContests(String keyword) {
		// TODO Auto-generated method stub
		return contestMapper.getNumberOfContests(keyword);
	}
	
	/**
	 * [此方法仅供管理员使用]
	 * 删除指定的竞赛.
	 * @param contestId - 试题的唯一标识符
	 */
	public boolean deleteContest(long contestId) {
		Long contestantNum = contestContestantMapper.getNumberOfContestantsOfContest(contestId);
		List<ContestSubmission> submissionsOfContest = contestSubmissionMapper.getSubmissionsOfContest(contestId);
		if(contestantNum == 0 && submissionsOfContest.isEmpty()) {
			contestMapper.deleteContest(contestId);
			return true;
		}
		return false;
	}
	
	/**
	 * 通过竞赛的唯一标识符获取竞赛的详细信息.
	 * @param contestId - 竞赛的唯一标识符
	 * @return 包含竞赛信息的Contest对象
	 */
	public Contest getContest(long contestId) {
		return contestMapper.getContest(contestId);
	}

	/**
	 * [此方法仅供管理员使用]
	 * 创建竞赛.
	 @param contestName - 竞赛名称
	 * @param contestMode - 竞赛模式	
	 * @param contestStartTime - 开始时间
	 * @param contestEndTime - 结束时间
	 * @param contestNotes - 竞赛描述
	 * @param contestProblems	- 包含试题(JSON 格式)
	 * @param request - HttpServletRequest对象	
	 * @return 包含竞赛创建结果的Map<String, Object>对象
	 */
	public Map<String, Object> createContest(String contestName,String contestMode,String contestStartTime,String contestEndTime,String contestNotes,String contestProblems){
		String DATE_FORMAT="yyyy-MM-dd HH:mm:ss"; 
		SimpleDateFormat format = new SimpleDateFormat(DATE_FORMAT);
		Date startTime = null;
		Date endTime = null;
		try {
			startTime = format.parse(contestStartTime);
			endTime = format.parse(contestEndTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		Contest contest = new Contest(contestName,contestNotes, startTime, endTime, contestMode, contestProblems);
		@SuppressWarnings("unchecked")
		Map<String, Object> result = (Map<String, Object>) getContestCreationResult(contest);
		
		if ( (boolean) result.get("isSuccessful") ) {
			contest.setProblems(contest.getProblems().replace("\"",""));
			contestMapper.createContest(contest);
			long contestId = contest.getContestId();
			result.put("contestId", contestId);
		}
		return result;
	}
	/**
	 * [此方法仅供管理员使用]
	 * 创建竞赛.
	 * @param contestId - 竞赛的唯一标识符
	 * @param contestName - 竞赛名称
	 * @param contestMode - 竞赛模式	
	 * @param contestStartTime - 开始时间
	 * @param contestEndTime - 结束时间
	 * @param contestNotes - 竞赛描述
	 * @param contestProblems	- 包含试题(JSON 格式)
	 * @param request - HttpServletRequest对象	
	 * @return 包含竞赛创建结果的Map<String, Object>对象
	 */
	public Map<String, Object> editContest(long contestId,String contestNotes,String contestName,String contestStartTime,String contestEndTime,String contestMode,String contestProblems){
		String DATE_FORMAT="yyyy-MM-dd HH:mm:ss"; 
		SimpleDateFormat format = new SimpleDateFormat(DATE_FORMAT);
		Date startTime = null;
		Date endTime = null;
		try {
			startTime = format.parse(contestStartTime);
			endTime = format.parse(contestEndTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		Contest contest = new Contest(contestId,contestNotes, contestName,startTime, endTime, contestMode, contestProblems);
		@SuppressWarnings("unchecked")
		Map<String, Object> result = (Map<String, Object>) getContestCreationResult(contest);
		
		if ( (boolean) result.get("isSuccessful") ) {
			contest.setProblems(contest.getProblems().replace("\"",""));
			contestMapper.updateContest(contest);
		}
		return result;
	}
	/**
	 * 检查创建竞赛信息是否合法.
	 * @param contest - 待创建的竞赛
	 * @return 包含竞赛创建结果的Map<String, Boolean>对象
	 */
	private Map<String, ? extends Object> getContestCreationResult(Contest contest) {
		Map<String, Boolean> result = new HashMap<>();
		result.put("isContestNameEmpty", contest.getContestName().isEmpty());
		result.put("isContestNameLegal", isContestNameLegal(contest.getContestName()));
		result.put("isTimeLegal", isContestTimeLegal(contest.getStartTime(),contest.getEndTime()));
		result.put("isProblemIdLegal", isContestProblemLegal(contest.getProblems()));
		boolean isSuccessful = !result.get("isContestNameEmpty")  &&  result.get("isContestNameLegal") &&
								result.get("isTimeLegal")	&&  result.get("isProblemIdLegal");
		result.put("isSuccessful", isSuccessful);
		return result;
	}
	/**
	 * 检查竞赛名称的合法性.
	 * @param problemName - 试题名称
	 * @return 竞赛名称是否合法
	 */
	private boolean isContestNameLegal(String contestName) {
		return contestName.length() <= 128;
	}
	/**
	 * 检查竞赛时间的合法性.
	 * @param startTime 开始时间
	 * @param endTime 结束时间
	 * @return 竞赛时间是否合法
	 */
	private boolean isContestTimeLegal(Date startTime,Date endTime) {
		Date nowTime = new Date();
		if(startTime==null||endTime==null||nowTime.after(startTime)||startTime.after(endTime))
			return false;
		return true;
	}
	/**
	 * 检查竞赛题目的合法性.
	 * @param contestProblems 竞赛题目（JSON 格式）
	 * @return 竞赛题目是否合法
	 */
	private boolean isContestProblemLegal(String contestProblems) {
	    JSONArray jsonArray = JSON.parseArray(contestProblems);
	    Pattern pattern = Pattern.compile("[0-9]*");
		for ( int i = 0; i < jsonArray.size(); ++ i ) {
			String problemIdStr = jsonArray.getString(i);
			Matcher isNum = pattern.matcher(problemIdStr);
	        if(!isNum.matches()){
	            return false;
	        }
			Long problemId = Long.parseLong(problemIdStr);
			if(problemMapper.getProblem(problemId) == null) {
				return false;
			}
		}
		return true;
	}
	
	
	/**
	 * 获取竞赛的试题列表.
	 * @param problemIdList - 包含竞赛试题ID列表的List对象
	 * @return 包含试题信息的List对象
	 */
	public List<Problem> getProblemsOfContests(List<Long> problemIdList) {
		List<Problem> problems = new ArrayList<>();
		for ( long problemId : problemIdList ) {
			Problem p = problemMapper.getProblem(problemId);

			if ( p != null ) {
				problems.add(p);
			}
		}
		return problems;
	}

	/**
	 * 获取某竞赛中某个用户各试题的提交记录.
	 * @param contestId - 竞赛的唯一标识符
	 * @param contestant - 参赛者
	 * @return 包含用户提交记录的Map对象, 按试题ID索引
	 */
	public Map<Long, ContestSubmission> getSubmissionsOfContestantOfContest(long contestId, User contestant) {
		if ( contestant == null ) {
			return null;
		}
		Map<Long, ContestSubmission> submissionsGroupByProblems = new HashMap<>();
		List<ContestSubmission> submissions = contestSubmissionMapper.
				getSubmissionOfContestOfContestant(contestId, contestant.getUid());

		for ( ContestSubmission cs : submissions ) {
			long problemId = cs.getSubmission().getProblem().getProblemId();

			if ( submissionsGroupByProblems.containsKey(problemId) ) {
				ContestSubmission prevSubmission = submissionsGroupByProblems.get(problemId);

				if ( prevSubmission.getSubmission().getJudgeResult().getJudgeResultSlug().equals("AC") &&
						!cs.getSubmission().getJudgeResult().getJudgeResultSlug().equals("AC") ) {
					continue;
				}
			}
			submissionsGroupByProblems.put(problemId, cs);
		}
		return submissionsGroupByProblems;
	}

	/**
	 * 获取某竞赛中某个用户某试题的提交记录.
	 * @param contest - 竞赛对象
	 * @param problemId - 试题的唯一标识符
	 * @param contestant - 参赛者对象
	 * @return 包含提交记录的List对象
	 */
	public List<Submission> getSubmissionsOfContestantOfContestProblem(
			Contest contest, long problemId, User contestant) {
		if ( contest == null || contestant == null ) {
			return null;
		}

		List<Submission> submissions = new ArrayList<>();
		if ( getContestStatus(contest) != Contest.CONTEST_STATUS.READY ) {
			List<ContestSubmission> css =  contestSubmissionMapper.getSubmissionOfContestOfContestProblem(
					contest.getContestId(), problemId, contestant.getUid());
			for ( ContestSubmission cs : css ) {
				submissions.add(cs.getSubmission());
			}
		}
		return submissions;
	}

	/**
	 * 获取用户在比赛中临时保存的代码 (一般用于保存OI赛制中的代码).
	 * @param contest - 竞赛对象
	 * @param problemId - 试题的唯一标识符
	 * @param contestant - 参赛者对象
	 * @return 包含对应试题的代码
	 */
	/*public Map<String, String> getCodeSnippetOfContestProblem(Contest contest, long problemId, User contestant) {
		if ( contest == null || contestant == null ) {
			return null;
		}
		if ( contest.getContestMode().equals("OI") && getContestStatus(contest) == Contest.CONTEST_STATUS.LIVE ) {
			ContestContestant cc = contestContestantMapper
					.getContestantOfContest(contest.getContestId(), contestant.getUid());
			Map<Long, Map<String, String>> codeSnippet = JSON.parseObject(cc.getCodeSnippet(),
					new TypeReference<Map<Long, Map<String, String>>>() {});

			if ( codeSnippet.containsKey(problemId) ) {
				return codeSnippet.get(problemId);
			}
		}
		return null;
	}*/

	/**
	 * 获取某竞赛的参赛人数.
	 * @param contestId - 竞赛的唯一标识符
	 * @return 某竞赛的参赛人数
	 */
	public long getNumberOfContestantsOfContest(long contestId) {
		return contestContestantMapper.getNumberOfContestantsOfContest(contestId);
	}

	/**
	 * 获取某个用户是否加入了某场竞赛.
	 * @param contestId - 竞赛的唯一标识符
	 * @param currentUser - 当前登录的用户对象
	 * @return 某个用户是否加入了某场竞赛
	 */
	public boolean isAttendContest(long contestId, User currentUser) {
		if ( currentUser == null ) {
			return false;
		}
		return contestContestantMapper.getContestantOfContest(contestId, currentUser.getUid()) != null;
	}

	/**
	 * 获取竞赛的当前状态 (未开始/进行中/已结束).
	 * @param contest - 待查询的竞赛
	 * @return 竞赛的当前状态
	 */
	private Contest.CONTEST_STATUS getContestStatus(Contest contest) {
		if ( contest == null ) {
			return null;
		}

		Date currentTime = new Date();
		if ( currentTime.before(contest.getStartTime()) ) {
			return Contest.CONTEST_STATUS.READY;
		} else if ( currentTime.after(contest.getEndTime()) ) {
			return Contest.CONTEST_STATUS.DONE;
		} else if ( currentTime.before(contest.getEndTime()) && currentTime.after(contest.getStartTime()) ) {
			return Contest.CONTEST_STATUS.LIVE;
		}
		return null;
	}

	/**
	 * 参加竞赛.
	 * @param contestId - 竞赛的唯一标识符
	 * @param currentUser - 当前登录的用户对象
	 * @return 包含是否成功参加竞赛状态信息的Map对象
	 */
	public Map<String, Boolean> attendContest(long contestId, User currentUser, boolean isCsrfTokenValid) {
		Contest contest = contestMapper.getContest(contestId);

		Map<String, Boolean> result = new HashMap<>(6, 1);
		result.put("isContestExists", contest != null);
		result.put("isContestReady", getContestStatus(contest) == Contest.CONTEST_STATUS.READY);
		result.put("isUserLogin", currentUser != null);
		result.put("isAttendedContest", isAttendContest(contestId, currentUser));
		result.put("isCsrfTokenValid", isCsrfTokenValid);

		boolean isSuccessful = result.get("isContestExists") &&  result.get("isContestReady")    &&
				               result.get("isUserLogin")     && !result.get("isAttendedContest") &&
							   result.get("isCsrfTokenValid");
		if ( isSuccessful ) {
			ContestContestant contestContestant = new ContestContestant(contest, currentUser);
			contestContestantMapper.createContestContestant(contestContestant);
		}
		result.put("isSuccessful", isSuccessful);
		return result;
	}

	/**
	 * 获取OI赛制的排行榜.
	 * @param contestId - 竞赛的唯一标识符
	 * @return 包含参赛者和提交记录信息的Map对象
	 */
	/*public Map<String, Object> getLeaderBoardForOi(long contestId) {
		Map<String, Object> result = new HashMap<>(3, 1);
		List<ContestContestant> contestants = contestContestantMapper.
				getContestantsOfContestForOi(contestId, 0, Integer.MAX_VALUE);
		Map<Long, Map<Long, Submission>> submissions = getSubmissionsGroupByContestant(
				contestSubmissionMapper.getSubmissionsOfContest(contestId), true);
		rankingContestants(contestants);

		result.put("contestants", contestants);
		result.put("submissions", submissions);
		return result;
	}*/

	/**
	 * 获取ACM赛制的排行榜.
	 * @param contestId - 竞赛的唯一标识符
	 * @return 包含参赛者和提交记录信息的Map对象
	 */
	public Map<String, Object> getLeaderBoardForAcm(long contestId) {
		Contest contest = contestMapper.getContest(contestId);

		Map<String, Object> result = new HashMap<>(3, 1);
		List<ContestContestant> contestants = contestContestantMapper.
				getContestantsOfContestForAcm(contestId, 0, Integer.MAX_VALUE);
		Map<Long, Map<Long, Submission>> acsubmissions = getSubmissionsGroupByContestant(
				contestSubmissionMapper.getAcceptedSubmissionsOfContest(contestId), false);
		Map<Long, Map<Long, Integer>> wrongsubmissions = getWrongSubmissionsGroupByContestant(
				contestSubmissionMapper.getSubmissionsOfContest(contestId));
		// 计算罚时
		for ( ContestContestant cc : contestants ) {
			long numberOfRejected = cc.getTime();
			long penalty = numberOfRejected * 1200;//每一次提交运行结果被判错误的话将被加罚20分钟时间
			if ( acsubmissions.containsKey(cc.getContestant().getUid()) ) {
				Map<Long, Submission> submissionsOfContestant = acsubmissions.get(cc.getContestant().getUid());

				for ( Map.Entry<Long, Submission> e : submissionsOfContestant.entrySet() ) {
					Submission s = e.getValue();
					long usedTimeInMilliseconds = s.getSubmitTime().getTime() - contest.getStartTime().getTime();
					s.setUsedTime(usedTimeInMilliseconds / 1000);
					penalty += s.getUsedTime();
				}
				cc.setTime(penalty);
			}
		}
		Collections.sort(contestants);
		rankingContestants(contestants);

		result.put("contestants", contestants);
		result.put("submissions", acsubmissions);
		result.put("wrongsubmissions", wrongsubmissions);
		return result;
	}

	/**
	 * 获取参赛者的排名.
	 * @param contestants - 竞赛参赛者列表
	 */
	public void rankingContestants(List<ContestContestant> contestants) {
		int currentRank = 1;
		if ( contestants.size() == 0 ) {
			return;
		}

		contestants.get(0).setRank(currentRank);
		for ( int i = 1; i < contestants.size(); ++ i ) {
			ContestContestant contestant = contestants.get(i);
			ContestContestant prevContestant = contestants.get(i - 1);
			//排名相同的情况
			if ( contestant.getScore() != prevContestant.getScore() || contestant.getTime() != prevContestant.getTime() ) {
				currentRank = i + 1;
			}
			contestant.setRank(currentRank);
		}
	}

	/**
	 * 建立竞赛提交通过记录的索引 (参赛者UID - 试题ID).
	 * @param contestSubmissions 包含全部竞赛提交记录的列表
	 * @param override - 当同一题出现多次提交时, 是否覆盖已有的提交记录
	 * @return 组织后的竞赛提交记录
	 */
	private Map<Long, Map<Long, Submission>> getSubmissionsGroupByContestant(
			List<ContestSubmission> contestSubmissions, boolean override) {
		Map<Long, Map<Long, Submission>> submissions = new HashMap<>();

		for ( ContestSubmission cs : contestSubmissions ) {
			long problemId = cs.getSubmission().getProblem().getProblemId();
			long contestantUid = cs.getSubmission().getUser().getUid();

			if ( !submissions.containsKey(contestantUid) ) {
				submissions.put(contestantUid, new HashMap<>());
			}
			Map<Long, Submission> submissionsOfContestant = submissions.get(contestantUid);

			if ( !override && submissionsOfContestant.containsKey(problemId) ) {
				continue;
			}
			submissionsOfContestant.put(problemId, cs.getSubmission());
		}
		return submissions;
	}
	/**
	 * 建立竞赛错误提交次数的索引 (参赛者UID - 试题ID).
	 * @param contestSubmissions 包含全部竞赛提交记录的列表
	 * @return 组织后的竞赛提交记录
	 */
	private Map<Long, Map<Long, Integer>> getWrongSubmissionsGroupByContestant(
			List<ContestSubmission> contestSubmissions) {
		Map<Long, Map<Long, Integer>> wrongSubmissions = new HashMap<>();

		for ( ContestSubmission cs : contestSubmissions ) {
			long problemId = cs.getSubmission().getProblem().getProblemId();
			long contestantUid = cs.getSubmission().getUser().getUid();
			if(cs.getSubmission().getJudgeResult().getJudgeResultSlug().equals("AC")) {
				continue;
			}
			if ( !wrongSubmissions.containsKey(contestantUid) ) {
				wrongSubmissions.put(contestantUid, new HashMap<>());
			}
			Map<Long, Integer> wrongSubmissionsOfContestant = wrongSubmissions.get(contestantUid);

			if (wrongSubmissionsOfContestant.containsKey(problemId) ) {
				wrongSubmissionsOfContestant.put(problemId,wrongSubmissionsOfContestant.get(problemId)-1);
			}else {
				wrongSubmissionsOfContestant.put(problemId,-1);
			}
		}
		return wrongSubmissions;
	}
	/**
	 * 将试题提交记录与竞赛创建关联
	 * @param contestId 竞赛的唯一标识符
	 * @param submissionId 试题的唯一标识符
	 */
	public void createContestSubmission(long contestId, long submissionId) {
		Contest contest = contestMapper.getContest(contestId);
		Submission submission = submissionMapper.getSubmission(submissionId);
		ContestSubmission contestSubmission = new ContestSubmission(contest,submission);
		contestSubmissionMapper.createContestSubmission(contestSubmission);
	}
	/**
	 * 自动注入的ContestMapper对象.
	 */
	@Autowired
	private ContestMapper contestMapper;
	/**
	 * 自动注入的SubmissionMapper对象.
	 */
	@Autowired
	private SubmissionMapper submissionMapper;
	/**
	 * 自动注入的ContestContestantMapper对象.
	 */
	@Autowired
	private ContestContestantMapper contestContestantMapper;

	/**
	 * 自动注入的ContestSubmissionMapper对象.
	 */
	@Autowired
	private ContestSubmissionMapper contestSubmissionMapper;

	/**
	 * 自动注入的ProblemMapper对象.
	 * 用于获取竞赛中的试题信息.
	 */
	@Autowired
	private ProblemMapper problemMapper;



}
