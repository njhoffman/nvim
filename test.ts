import matter from "gray-matter";
import { ignoreTokens } from "./ignoreTokens.js";

const markerFindAndReplaceContent = function(content: string, marker: string, value: string): string {
  const _content = content;
  return _content.replace(new RegExp(`{${marker}}`, "g"), `${value}`);
};

export const composeWithoutTemplate = async function(asset: AssetType): Promise<AssetType> {
  const fm = matter(asset.content as string);
  for (const [key, value] of Object.entries(fm.data)) {
    if (!ignoreTokens.includes(key)) {
      fm.content = markerFindAndReplaceContent(fm.content, key, value);
      console.log("fm.content", fm.content);
    }
  }
  return asset;
};
