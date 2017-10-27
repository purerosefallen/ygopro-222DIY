--夏 秋 回 转 赞 歌
local m=46564043
local cm=_G["c"..m]
function cm.initial_effect(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1) 
	--colour summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.effcon)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	e2:SetLabel(TYPE_SYNCHRO)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	e5:SetLabel(TYPE_FUSION)
	c:RegisterEffect(e5)	
	--check material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(cm.valcheck)
	c:RegisterEffect(e6)
end
function cm.filter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevelAbove(4) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.mtfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND)
end
function cm.valcheck(e,c)
	if c:GetMaterial():IsExists(cm.mtfilter,1,nil) then
		c:RegisterFlagEffect(m,RESET_EVENT+0x4fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:GetFirst():IsType(e:GetLabel()) and eg:GetFirst():GetFlagEffect(m)~=0
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local hg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
	end
	Duel.Draw(1-tp,1,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
end
function cm.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end 
end
