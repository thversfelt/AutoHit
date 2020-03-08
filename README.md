# AutoHit
A simple AutoHotkey script to assist judge work on [UHRS](https://prod.uhrs.playmsn.com/Judge/Views/Login.aspx).

![image](https://user-images.githubusercontent.com/40113382/75798152-72193480-5d76-11ea-81b7-64d00f007fe8.png)

I use this script in my work as an Ad Evaluator. I noticed that I spent about 5-10s moving my cursor to select my ratings and to submit it. When the HitApp requires you to evaluate 135 hits per hour, every hit should take about ~27s. So, about 30% of my time was spent on selecting the right judgement and submitting it. By automating this process, I have dramatically reduced my workload and improved my productivity.

## Features:
- Automatically clicks the corresponding rating and submits it
- Set a goal of *x* hits in *y* minutes, to improve your productivity
- Dynamically adjusts the countdown timer based on the progress to your goal

## How to use it:
1. Download the latest [release](https://github.com/thversfelt/AutoHit/releases)
2. Login to [UHRS](https://prod.uhrs.playmsn.com/Judge/Views/Login.aspx)
3. Start your preffered HitApp
4. Run `AutoHit.exe`
5. Set your goal (by default 68 hits in 30 minutes)
6. Select your judgement by clicking the corresponding button, AutoHit will submit your judgement instantly

## Tips:
- Make sure your browser is internet explorer, as recommended by your employer
- Make sure your browser is in full-screen, AutoHit sometimes doesn't work as expected otherwise
- AutoHit also works using shortcuts:
  * `Ctrl+p` = Perfect
  * `Ctrl+e` = Excellent
  * `Ctrl+g` = Good
  * `Ctrl+f` = Fair
  * `Ctrl+b` = Bad
  * `Ctrl+u` = Unsure
