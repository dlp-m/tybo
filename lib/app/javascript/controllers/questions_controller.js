import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['questionKind', 'questionType', 'newQuestion', 'choices', 'documentType']

  changeType(e) {
    let questionType = e.target.selectedOptions[0].value
    let kindInput = this.questionKindTarget
    this.getKindInput(questionType, kindInput)
  }


  getKindInput(questionType, kindInput) {
    fetch(`/admin/questions/kinds?type=${questionType}`, {
      method: 'GET',
    }).then(response => response.json())
      .then(data => {
        kindInput.options.length = 0 // reset options in select
        data.unshift('')
        for (let i in data) { // feed options in select with data array
          kindInput.options[kindInput.options.length] = new Option(data[i][0], data[i][1]);
        }
        this.displayChoiceBtn()
      })
  }
  changeKind() {
    this.displayChoiceBtn()
    this.removeChoices()
  }

  removeChoices() {
    document.getElementById('choices').innerHTML = ''
  }

  updateChoicePartial() {
    let questionKind = this.questionKindTarget.selectedOptions[0].value
    let questionType = this.questionTypeTarget.selectedOptions[0].value
    let choices = this.choicesTarget
    fetch(`/admin/questions/update_nested_form?type=${questionType}&kind=${questionKind}`, {
      method: 'GET',
    }).then(response => response.json())
      .then(data => {
        choices.innerHTML = data
      })
  }
  displayChoiceBtn() {
    let questionKind = this.questionKindTarget.selectedOptions[0].value
    let questionType = this.questionTypeTarget.selectedOptions[0].value
    let btn = document.getElementById('add-choice')
    if (Boolean(questionKind) && Boolean(questionType) && questionType != "Questions::Input") {
      btn.classList.remove('hidden')
    } else {
      btn.classList.add('hidden')
    }
  }

  addQuestion() {
    this.newQuestionTargets[0].classList.remove('hidden')
    location.hash = "#" + 'newQuestion';
  }
}
