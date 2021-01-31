import java.util.HashMap;
import java.util.List;
import java.util.HashSet;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.io.IOException;
import java.nio.file.*;

class Content {
    private String type;
    private int number;

    public String getType() {
        return type;
    }

    public void setType(String value) {
        type = value;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int value) {
        number = value;
    }

}

class Program {
    public static void main(String[] args) {
        try {
            var bagContent = analyseFile(".\\data");

            var findContent = getAllContentForType("shiny gold", bagContent);
            System.out.println("results : " + findContent.size() + "\n");

            System.out.println("result Content : " + bagContentNumber("shiny gold", bagContent) + "\n");
        }
        catch (IOException ex) {
            System.out.println("error :" + ex.getMessage());
        }

        
    }

    private static int bagContentNumber(String type, HashMap<String, List<Content>> references) {
        var bagNumberFound = new HashMap<String, Integer>();

        return getContentNumber(type, references, bagNumberFound);
    }

    private static int getContentNumber(String type, HashMap<String, List<Content>> references,
            HashMap<String, Integer> bagNumberFound) {
        if (bagNumberFound.containsKey(type)) {
            return bagNumberFound.get(type);
        }

        var item = references.get(type);

        if (item.size() == 0) {
            return 0;
        }

        var contentNumber = item.stream()
                .map(x -> x.getNumber() * (1 + getContentNumber(x.getType(), references, bagNumberFound)))
                .mapToInt(Integer::intValue).sum();
        bagNumberFound.put(type, contentNumber);
        return contentNumber;
    }

    private static HashSet<String> getAllContentForType(String type, HashMap<String, List<Content>> references) {
        var validate = new HashSet<String>();

        var contentBag = getContentForType(type, references);

        while (contentBag.size() != 0) {
            var item = contentBag.get(0);
            contentBag.remove(0);

            if (!validate.contains(item)) {
                validate.add(item);
                references.remove(item);
                contentBag.addAll(getContentForType(item, references));
            }
        }

        return validate;
    }

    private static List<String> getContentForType(String type, HashMap<String, List<Content>> references) {
        var contentBag = references.entrySet().stream()
                .filter(x -> x.getValue().stream().anyMatch(c -> c.getType().equals(type))).map(x -> x.getKey());

        return contentBag.collect(Collectors.toList());
    }

    private static HashMap<String, List<Content>> analyseFile(String filePath) throws IOException {
        var lines = Files.lines(Path.of(filePath));

        Pattern bagPattern = Pattern.compile("([a-zA-Z\\s]+) bags contain[^,.].*");
        Pattern contentPattern = Pattern.compile("(\\d+) ([a-zA-Z\\s]+) bags{0,1}");

        var bagContent = new HashMap<String, List<Content>>();

        lines.forEach(x -> {
            var bagMatcher = bagPattern.matcher(x);
            var contentMatcher = contentPattern.matcher(x);

            var contents = contentMatcher.results().map(r -> {

                return new Content() {
                    {
                        setNumber(Integer.parseInt(r.group(1)));
                        setType(r.group(2));
                    }
                };
            });

            if (bagMatcher.matches())
                bagContent.put(bagMatcher.group(1), contents.collect(Collectors.toList()));

        });

        lines.close();
        return bagContent;
    }
}