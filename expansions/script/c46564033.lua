--冬 谧  雪 中 愿 小 七
local m=46564033
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--become material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(0x14000)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ft=Duel.GetMZoneCount(tp)
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsAttribute,c,ATTRIBUTE_WATER)
		local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,0,nil)
		mg:Merge(mg2)
		if c.mat_filter then
			mg=mg:Filter(c.mat_filter,nil)
		end
		if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) then return end
		if ft>0 then
			return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),0,99,c)
		else
			return mg:IsExists(cm.mfilterf,1,nil,tp,mg,c)
		end
	end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsAttribute,c,ATTRIBUTE_WATER)
	local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,0,nil)
	if c.mat_filter then
		mg=mg1:Filter(c.mat_filter,nil)
	end
	local mg=mg1:Filter(Card.IsCanBeRitualMaterial,c,c)
		mg:Merge(mg2)
	local mat=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,c:GetLevel(),0,99,c)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,c)
		Duel.SetSelectedCard(mat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,c:GetLevel(),0,99,c)
		mat:Merge(mat2)
	end
	c:SetMaterial(mat)
	Duel.ReleaseRitualMaterial(mat)
	Duel.BreakEffect()
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
	c:CompleteProcedure()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_RITUAL)~=0
end
function cm.thfilter(c)
	return c:IsRace(RACE_AQUA) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	Duel.BreakEffect()
	if not Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
	end
end
