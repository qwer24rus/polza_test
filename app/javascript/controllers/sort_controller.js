import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    sort_dishes() {
        const dishes = document.querySelectorAll('div.single_product');
        let checked_checkboxes = this.element.querySelectorAll('input[id^=order_not_included_ingredients]:checked')
        let checked_ids = [...checked_checkboxes].map(element => parseInt(element.value, 10));
        for (let element of dishes) {
            let ingredients = JSON.parse(element.dataset.ingredients);
            if (checked_ids.filter(element => ingredients.indexOf(element) !== -1).length === 0) {
                element.classList.replace("hide", "show");
            }
            else {
                element.classList.replace("show", "hide");
            }
        }
    }
}