--WL·紫 毒 精 灵
local m=46564050
local cm=_G["c"..m]
function cm.initial_effect(c)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(cm.destg)
	e5:SetOperation(cm.desop)
	c:RegisterEffect(e5)
	--spsummom or to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
	if sg:GetCount()>0 and Duel.Destroy(sg,REASON_EFFECT)~=0 then
		Duel.ConfirmDecktop(tp,1)
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		if tc:IsSetCard(0x65c) and tc:IsType(TYPE_MONSTER) and tc:IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		else
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
		end
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function cm.cfilter(c,e,tp)
	return c:IsSetCard(0x65c) and c:IsType(TYPE_MONSTER) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsAbleToGrave())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local ft=Duel.GetMZoneCount(tp)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<1 or Duel.SelectYesNo(tp,aux.Stringid(m,4))) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
