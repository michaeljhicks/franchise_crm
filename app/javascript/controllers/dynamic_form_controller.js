import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Define the targets we need to access
  static targets = ["modelContainer", "otherContainer"]

  // This is the list of Ice-O-Matic models
  iceOMaticModels = [ "B1000-48", "B110PS", "B1300-48", "B1600-60", "B40PS", "B42PS", "B55PS", "B700-30", "BPF-1", "CD40022", "CD40030", "CD40130", "CIM0320FA", "CIM0320FW", "CIM0320HA", "CIM0320HW", "CIM0326FA", "CIM0326HA", "CIM0330FA", "CIM0330FW", "CIM0330HA", "CIM0330HW", "CIM0430FA", "CIM0430FW", "CIM0430HA", "CIM0430HW", "CIM0436FA", "CIM0436FW", "CIM0436HA", "CIM0436HW", "CIM0520FA", "CIM0520FW", "CIM0520HA", "CIM0520HW", "CIM0526FA", "CIM0526HA", "CIM0530FA", "CIM0530FR", "CIM0530FW", "CIM0530HA", "CIM0530HR", "CIM0530HW", "CIM0636FA", "CIM0636FR", "CIM0636FW", "CIM0636HA", "CIM0636HR", "CIM0636HW", "CIM0826FA", "CIM0826FA49", "CIM0826FR", "CIM0826FR49", "CIM0826FW", "CIM0826HA", "CIM0826HA49", "CIM0826HR", "CIM0826HR49", "CIM0826HW", "CIM0836FA", "CIM0836FA49", "CIM0836FR", "CIM0836FR49", "CIM0836FW", "CIM0836GA", "CIM0836HA", "CIM0836HA49", "CIM0836HAS", "CIM0836HR", "CIM0836HR49", "CIM0836HRS", "CIM0836HW", "CIM1126FA", "CIM1126FA49", "CIM1126FR", "CIM1126FR49", "CIM1126FW", "CIM1126HA", "CIM1126HA49", "CIM1126HR", "CIM1126HR49", "CIM1126HW", "CIM1136FA", "CIM1136FA49", "CIM1136FR", "CIM1136FR49", "CIM1136FW", "CIM1136HA", "CIM1136HA49", "CIM1136HR", "CIM1136HR49", "CIM1136HW", "CIM1446FA", "CIM1446FA49", "CIM1446FR", "CIM1446FR49", "CIM1446FW", "CIM1446HA", "CIM1446HA49", "CIM1446HR", "CIM1446HR49", "CIM1446HW", "CIM1447FA", "CIM1447FR", "CIM1447FW", "CIM1447HA", "CIM1447HR", "CIM1447HW", "CIM2046FR", "CIM2046FR49", "CIM2046FW", "CIM2046HR", "CIM2046HR49", "CIM2046HW", "CIM2047FR", "CIM2047FW", "CIM2047HR", "CIM2047HW", "GEM0450A", "GEM0450W", "GEM0650A", "GEM0650R", "GEM0650W", "GEM0956A", "GEM0956R", "GEM0956W", "GEM1306A", "GEM1306R", "GEM2006R", "GEM2006R49", "GEM2006W", "GEMD270A2", "GEMU090", "GRILL10", "GRILL20", "GRILL30", "Ice-O-Matic", "ICE1506HR", "ICE1506HR49", "ICE1506HT", "ICE1506HT49", "ICEU220FA", "ICEU220HA", "ICEU226FA", "ICEU226HA", "ICEU300FA", "ICEU300FW", "ICEU300HA", "ICEU300HW", "IFI4C", "IFI8C", "IFQ1", "IFQ1S", "IFQ1XL", "IFQ2", "IFQ2XL", "IOD150", "IOD200", "IOD250", "IOMQ", "IOMQS", "IOMQXL", "IOMWFRC", "K2230S", "KBT15022", "KBT19", "KBT222", "KBT23", "KBT24", "KBT25022", "KBT25030", "KBT5", "KBTF21506", "KBTF230", "KCFS71-30", "KCFS9-22", "KCFS9-30", "KCFS91-22", "KCFS91-30", "KCUBEDISP", "KFS7-22", "KFS7-30", "KFS7-G", "KGEMDISP", "KGEMFS-01", "KIBB", "KIBD-01", "KICEP", "KLSCO", "KPBRA", "KPU090", "KRL-25", "KRL-40", "KRL-75", "KRWD-01", "KSHOB", "KSHOV", "KSI-1", "KSSCO", "KWGFID", "MFI0500A", "MFI0500W", "MFI0800A", "MFI0800R", "MFI0800W", "MFI1256A", "MFI1256R", "MFI1256W", "MFI1506A", "MFI1506R", "MFI2306R", "MFI2306W", "RC100C40 RCA1001", "RC100G40 RGA0501-HM", "RC106C40 RCA1061", "RC106G40 RGA1061-HM", "RC206C40 RCA2061", "RC206C49", "RC306C40 RCA3061", "RC306C49", "RC406C40 RCA3561", "RC406C49", "RCA3061", "RL404-25 RT325-404", "RL404-40 RT340-404", "RL404-75 RT375-404", "RL49-25", "RL49-40", "RL49-75", "UCG060A", "UCG080A", "UCG100A", "UCG130A" ];

  // This action runs whenever a dropdown with data-action="...#toggleOther" is changed
  toggleOther(event) {
    // Find the very next element that is an "otherContainer" target
    const otherContainer = event.target.closest("div").nextElementSibling
    
    if (event.target.value === 'Other') {
      otherContainer.classList.remove('hidden')
    } else {
      otherContainer.classList.add('hidden')
      // Clear the text field if another option is chosen
      const input = otherContainer.querySelector("input")
      if (input) {
        input.value = ""
      }
    }
  }

  // This action runs whenever the Machine Make dropdown is changed
  toggleModelField(event) {
    const selectedMake = event.target.value;
    let newField;

    if (selectedMake === 'Ice-O-Matic') {
      // Build an HTML string for the dropdown
      const options = this.iceOMaticModels.map(model => `<option value="${model}">${model}</option>`).join('');
      newField = `
        <label for="machine_machine_model">Machine model</label>
        <select name="machine[machine_model]" id="machine_machine_model">
          <option value="">Select a model</option>
          ${options}
        </select>
      `;
    } else {
      // Build an HTML string for the text field
      newField = `
        <label for="machine_machine_model">Machine model</label>
        <input type="text" name="machine[machine_model]" id="machine_machine_model">
      `;
    }

    // Replace the content of the container with our new HTML
    this.modelContainerTarget.innerHTML = newField;
  }
}