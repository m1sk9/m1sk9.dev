// 2005/09/02 (JST - UTC+9)
const BIRTHDATE = new Date("2005-09-02T00:00:00+09:00")

const now = new Date();
const nowJST = new Date(now.toLocaleString("en-US", { timeZone: "Asia/Tokyo" }));

let age = nowJST.getFullYear() - BIRTHDATE.getFullYear();
const monthDiff = nowJST.getMonth() - BIRTHDATE.getMonth();
const dayDiff = nowJST.getDate() - BIRTHDATE.getDate();

if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
  age--;
}
document.getElementById("age").textContent = age + 'yo'
