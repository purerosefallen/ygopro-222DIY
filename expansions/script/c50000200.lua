--灵依法师－升灵
function c50000200.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --SUMMON_TYPE_RITUAL
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetDescription(aux.Stringid(50000200,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c50000200.target)
    e1:SetOperation(c50000200.operation)
    c:RegisterEffect(e1)
    --pzone sp
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50000200,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,50000200)
    e2:SetCost(c50000200.spcost)
    e2:SetTarget(c50000200.sptg)
    e2:SetOperation(c50000200.spop)
    c:RegisterEffect(e2)
    --hand sp
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetDescription(aux.Stringid(50000200,2))
    e3:SetCode(EFFECT_SPSUMMON_PROC)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e3:SetRange(LOCATION_HAND)
    e3:SetCondition(c50000200.spcon)
    c:RegisterEffect(e3)
    --tohand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50000200,3))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_RELEASE)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,500002001)
    e4:SetTarget(c50000200.thtg)
    e4:SetOperation(c50000200.thop)
    c:RegisterEffect(e4)
end
c50000200.is_named_with_Rely=1
function c50000200.IsRely(c)
    local code=c:GetCode()
    local mt=_G["c"..code]
    if not mt then
        _G["c"..code]={}
        if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
            mt=_G["c"..code]
            _G["c"..code]=nil
        else
            _G["c"..code]=nil
            return false
        end
    end
    return mt and mt.is_named_with_Rely
end
--SUMMON_TYPE_RITUAL
function c50000200.ritual_filter(c)
    return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER) 
end
function c50000200.filter(c,e,tp,m,ft)
    if not c50000200.ritual_filter(c) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    if c:IsCode(21105106) then return c:ritual_custom_condition(mg,ft) end
    if ft>0 then
        return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
    else
        return mg:IsExists(c50000200.mfilterf,1,nil,tp,mg,c)
    end
end
function c50000200.mfilterf(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
    else return false end
end
function c50000200.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp)
        local ft=Duel.GetMZoneCount(tp)
        return ft>-1 and Duel.IsExistingMatchingCard(c50000200.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c50000200.operation(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetRitualMaterial(tp)
    local ft=Duel.GetMZoneCount(tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,c50000200.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
    local tc=tg:GetFirst()
    if tc then
        mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        if tc:IsCode(21105106) then
            tc:ritual_custom_operation(mg)
            local mat=tc:GetMaterial()
            Duel.ReleaseRitualMaterial(mat)
        else
            local mat=nil
            if ft>0 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
            else
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                mat=mg:FilterSelect(tp,c50000200.mfilterf,1,1,nil,tp,mg,tc)
                Duel.SetSelectedCard(mat)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
                local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
                mat:Merge(mat2)
            end
            tc:SetMaterial(mat)
            Duel.ReleaseRitualMaterial(mat)
        end
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
--pzone sp
function c50000200.cfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER)
end
function c50000200.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c50000200.cfilter,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    local g=Duel.SelectReleaseGroup(tp,c50000200.cfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c50000200.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>-1
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50000200.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetMZoneCount(tp)<=0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
--hand sp
function c50000200.hspfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER)
end
function c50000200.spcon(e,c)
    if c==nil then return true end
    return Duel.GetMZoneCount(c:GetControler())>0
        and Duel.IsExistingMatchingCard(c50000200.hspfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
--to hand
function c50000200.thfilter(c)
    return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER)  and (c:IsType(TYPE_RITUAL) or c:IsType(TYPE_PENDULUM)) and not c:IsCode(50000200) and c:IsAbleToHand()
end
function c50000200.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50000200.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50000200.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c50000200.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end