import "core/rhai/kinds.rhai" as kinds;
import "core/rhai/configuration.rhai" as configuration;
import "core/shared/whitespace.rhai" as whitespace;
import "core/shared/comments.rhai" as comments;

fn doc_concat_list(docs) {
    if docs.len() == 0 {
        return doc_text("");
    }
    if docs.len() == 1 {
        return docs[0];
    }
    doc_concat(docs)
}
