function validateLogin() {
    const email = document.getElementById("loginEmail");
    const password = document.getElementById("loginPassword");
    if (!email || !password) return true;
    if (!email.value.trim() || !password.value) {
        alert("Please enter your email and password.");
        return false;
    }
    return true;
}

function validateRegister() {
    const name = document.getElementById("registerName");
    const email = document.getElementById("registerEmail");
    const password = document.getElementById("registerPassword");
    if (!name || !email || !password) return true;
    if (name.value.trim().length < 2) {
        alert("Please enter your name.");
        return false;
    }
    if (password.value.length < 6) {
        alert("Password must be at least 6 characters.");
        return false;
    }
    return true;
}

function validateItemForm() {
    const title = document.getElementById("itemTitle");
    const type = document.getElementById("itemType");
    const location = document.getElementById("itemLocation");
    const contact = document.getElementById("itemContact");
    if (!title || !type || !location || !contact) return true;
    if (!title.value.trim() || !type.value || !location.value.trim() || !contact.value.trim()) {
        alert("Please fill in all required fields.");
        return false;
    }
    return true;
}