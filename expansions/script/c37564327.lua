--四季的流转者·Kana
local m=37564327
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_kana=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,false,table.unpack(cm.filters))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	Senya.NegateEffectModule(c,63,nil,Senya.DescriptionCost(cm.cost(c)))
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37564765,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(Senya.DescriptionCost(cm.cost(c)))
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(Senya.DescriptionCost(cm.cost(c)))
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
cm.filters={
	aux.FilterBoolFunction(Card.IsFusionSetCard,0x65a),
	aux.FilterBoolFunction(Card.IsFusionSetCard,0x5334),
	aux.FilterBoolFunction(Card.IsFusionSetCard,0xc330),
	aux.FilterBoolFunction(Card.IsFusionSetCard,0x65b),
}
function cm.SawawaRemoveCostFilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and ((c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND)) or (c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_WATER))) and math.max(c:GetLevel(),c:GetRank())<=8 and Senya.CheckSummonLocation(c,tp)
end
function cm.cost(c)
	local dchk=c:IsStatus(STATUS_COPYING_EFFECT) and c:GetFlagEffectLabel(37564768) or 0
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local ctlm=math.max(dchk,1)
		if chk==0 then return c:GetFlagEffect(m)<ctlm end
		c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SpecialSummon(g,SUMMON_TYPE_SPECIAL,tp,tp,true,true,POS_FACEUP)
		local tc=g:GetFirst()
		tc:CompleteProcedure()
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(m-4000,RESET_EVENT+0x1fe0000,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(cm.thcon)
		e1:SetOperation(cm.thop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local ex=e:GetLabelObject():IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and 0 or 2
	Duel.SendtoDeck(e:GetLabelObject(),nil,ex,REASON_EFFECT)
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and ((c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND)) or (c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_WATER)))
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
	local fg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return fg:GetCount()>0 and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,fg:GetCount(),nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local fg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
	if not tg or tg:GetCount()==0 or tg:GetCount()>fg:GetCount() then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 and ct<=fg:GetCount() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=fg:Select(tp,1,ct,nil):Filter(Senya.NonImmuneFilter,nil,e)
		Duel.HintSelection(sg)
		Senya.ExileGroup(sg)
		Duel.SendtoGrave(sg,REASON_RULE+REASON_RETURN)
	end
end