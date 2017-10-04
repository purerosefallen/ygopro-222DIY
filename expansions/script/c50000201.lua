--灵依法师－降灵
function c50000201.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --SUMMON_TYPE_RITUAL
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetDescription(aux.Stringid(50000201,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c50000201.target)
    e1:SetOperation(c50000201.operation)
    c:RegisterEffect(e1)
    --atk-def up
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50000201,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,50000201)
    e2:SetCost(c50000201.adcost)
    e2:SetTarget(c50000201.adtg)
    e2:SetOperation(c50000201.adop)
    c:RegisterEffect(e2)
    --tohand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50000201,2))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetTarget(c50000201.thtg)
    e3:SetOperation(c50000201.thop)
    c:RegisterEffect(e3)
    --tohand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50000201,3))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_RELEASE)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,500002011)
    e4:SetTarget(c50000201.sptg)
    e4:SetOperation(c50000201.spop)
    c:RegisterEffect(e4)
end
c50000201.is_named_with_Rely=1
function c50000201.IsRely(c)
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
function c50000201.ritual_filter(c)
    return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER) 
end
function c50000201.filter(c,e,tp,m,ft)
    if not c50000201.ritual_filter(c) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    if c:IsCode(21105106) then return c:ritual_custom_condition(mg,ft) end
    if ft>0 then
        return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
    else
        return mg:IsExists(c50000201.mfilterf,1,nil,tp,mg,c)
    end
end
function c50000201.mfilterf(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
    else return false end
end
function c50000201.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp)
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return ft>-1 and Duel.IsExistingMatchingCard(c50000201.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg,ft)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c50000201.operation(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetRitualMaterial(tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,c50000201.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg,ft)
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
                mat=mg:FilterSelect(tp,c50000201.mfilterf,1,1,nil,tp,mg,tc)
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
--atk-def up
function c50000201.cfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER)
end
function c50000201.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c50000201.cfilter,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    local g=Duel.SelectReleaseGroup(tp,c50000201.cfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c50000201.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50000201.cfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c50000201.adop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c50000201.cfilter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(800)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end
--thand
function c50000201.thfilter(c)
    return c50000201.IsRely(c) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c50000201.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50000201.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50000201.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c50000201.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--hdsp
function c50000201.sdfilter(c,e,tp)
    return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c50000201.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c50000201.sdfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c50000201.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c50000201.sdfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local sc=g:GetFirst()
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)        
        sc:CompleteProcedure()
    end
end