# Bug Report Writing

Report bug chuẩn: steps, expected/actual, evidence, severity.

## Khi nào dùng
- Ghi bug cho Dev xử lý
- Test role phát hiện lỗi
- Review regression failures

## Template
```md
# Bug: [Short title]

## Environment
App/service, branch/build, browser/device, data set

## Preconditions
Required setup/data/user role

## Steps to Reproduce
1. ...
2. ...
3. ...

## Actual Result
What happened

## Expected Result
What should happen

## Evidence
Screenshot/video/log/API response

## Impact
User/business impact

## Severity
Critical/High/Medium/Low

## Suspected Area
Optional: files/modules likely involved
```

## Severity Guide
- Critical: data loss/security/system down
- High: core flow blocked
- Medium: workaround exists
- Low: cosmetic/minor issue
