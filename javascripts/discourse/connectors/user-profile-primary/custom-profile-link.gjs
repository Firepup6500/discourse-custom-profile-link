/* global settings */
/* eslint-disable no-console */
import Component from "@glimmer/component";

export default class CustomProfileLink extends Component {
  get links() {
    if (settings.custom_profile_link_debug_mode) {
      console.debug("[Custom Profile Link] Settings dump follows", settings);
    }
    const ids = settings.custom_profile_link_user_field_ids
    .replace(/_/g, "")
    .split(/\|/)
    .map(Number);
    const labels = settings.custom_profile_link_labels.split(/\|/);
    const prefixes = settings.custom_profile_link_prefixes.split(/\|/);
    const parsedSettings = { ids, labels, prefixes };
    if (settings.custom_profile_link_debug_mode) {
      console.debug(
        "[Custom Profile Link] Parsed settings dump follows",
        parsedSettings,
      );
    }
    let links = [];
    if (settings.custom_profile_link_debug_mode) {
      console.debug("[Custom Profile Link] args dump:", this.args.outletArgs);
    }
    if (!this.args.outletArgs.model.get("user_fields")) {
      console.warn(
        `[Custom Profile Link] User Profile () missing "user_fields"! Raw user dump follows.`,
                   this.args.outletArgs.model,
      );
      return undefined;
    } else {
      for (let i = 0; i < ids.length; i++) {
        if (
          !this.args.outletArgs.model.get("user_fields")[ids[i]] &&
          settings.custom_profile_link_debug_mode
        ) {
          console.debug(
            `[Custom Profile Link] User field ${ids[i]} missing. user_fields dump follows.`,
            this.args.outletArgs.model.get("user_fields"),
          );
        }
        if (this.args.outletArgs.model.get("user_fields")[ids[i]]) {
          links.push({
            value: this.args.outletArgs.model.get("user_fields")[ids[i]],
                     label: labels[i],
                     prefix: prefixes[i],
          });
        }
      }
      if (settings.custom_profile_link_debug_mode) {
        console.debug("[Custom Profile Link] links built, dump:", links);
      }
      return links;
    }
  }

  get orgs() {
    const orgsData = settings.custom_profile_link_orgs.split(/\|/);
    let orgs = [];
    if (!this.args.outletArgs.model.get("user_fields")) {
      return undefined;
    } else {
      for (let i = 0; i < orgsData.length; i++) {
        let data = orgsData[i].split(/,/);
        data[1] = parseInt(data[1], 10);
        data[2] = parseInt(data[2], 10);
        if (
          (!this.args.outletArgs.model.get("user_fields")[data[1]] ||
          !this.args.outletArgs.model.get("user_fields")[data[2]]) &&
          settings.custom_profile_link_debug_mode
        ) {
          console.debug(
            `[Custom Profile Link] Part of orgs data missing. user_fields dump follows.`,
            this.args.outletArgs.model.get("user_fields"),
          );
        }
        // Handle only having a url
        if (
          !this.args.outletArgs.model.get("user_fields")[data[1]] &&
          !!this.args.outletArgs.model.get("user_fields")[data[2]]
        ) {
          data[1] = data[2];
        }
        if (
          !!this.args.outletArgs.model.get("user_fields")[data[1]] &&
          !!this.args.outletArgs.model.get("user_fields")[data[2]]
        ) {
          orgs.push({
            label: data[0],
            name: this.args.outletArgs.model.get("user_fields")[data[1]],
                    url: this.args.outletArgs.model.get("user_fields")[data[2]],
          });
        }
      }
    }
    if (settings.custom_profile_link_debug_mode) {
      console.debug("[Custom Profile Link] orgs built, dump:", orgs);
    }
    return orgs;
  }

  <template>
  {{#if this.links}}
  <div class="public-user-fields">
  <div class="public-user-field">
  <span class="user-field-value">
  {{#each this.links as |link|}}
  <a href="{{link.prefix}}{{link.value}}" target="_blank">{{link.label}}</a>
  {{/each}}
  {{#if this.orgs}}
  <br />
  {{#each this.orgs as |org|}}
  {{org.label}}:
  <a href="{{org.url}}" target="_blank">{{org.name}}</a>
  {{/each}}
  {{/if}}
  </span>
  </div>
  </div>
  {{/if}}
  </template>
}
