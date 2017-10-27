--Hard Drive Divinity! 女神进化！
nep=nep or {}
local m=73205005
local cm=_G["c"..m]
--card part
if cm then

--cm.named_with_nep=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.tfilter(c,att,e,tp)
	return nep.isnep(c) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsType(TYPE_FUSION)
end
function cm.filter(c,e,tp)
	return c:IsFaceup() and nep.isnep(c)
		and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetOriginalAttribute(),e,tp) and not c:IsType(TYPE_FUSION)
end
function cm.chkfilter(c,att)
	return c:IsFaceup() and nep.isnep(c) and bit.band(c:GetOriginalAttribute(),att)~=0 and not c:IsType(TYPE_FUSION)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.GetMZoneCount(tp)>-1
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabel(g:GetFirst():GetOriginalAttribute())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local att=tc:GetOriginalAttribute()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,att,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		if Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,m*16+1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

end
--global part
table=require("table")
function nep.isnep(c)
	local code=c:GetCode()
	if code==88071625 then return true end
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
	return mt and mt.named_with_nep
end
function nep.global1(c,code)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73205005,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,code)
	e1:SetTarget(nep.target1)
	e1:SetOperation(nep.operation1)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function nep.filter1(c)
	return c:IsCode(73205005) and c:IsAbleToHand()
end
function nep.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nep.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function nep.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,nep.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function nep.global2(c,code,tcode,scode)
	c:SetSPSummonOnce(code)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73205005,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetLabel(tcode)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(nep.thtg1)
	e1:SetOperation(nep.tgop1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(73205005,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,0x1e0)
	e3:SetLabel(scode)
	e3:SetCost(nep.cost2)
	e3:SetTarget(nep.target2)
	e3:SetOperation(nep.operation2)
	c:RegisterEffect(e3)
end
function nep.thfilter1(c,tcode)
	return c:IsCode(tcode) and c:IsAbleToHand()
end
function nep.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nep.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function nep.tgop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,nep.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function nep.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function nep.filter2(c,e,tp)
	return c:IsCode(e:GetLabel()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function nep.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and nep.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>-1
		and Duel.IsExistingTarget(nep.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,nep.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function nep.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function nep.global3(c,ccode,loc,f,ctg,op,...)
	local ext_params={...}
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(ctg)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(nep.condition3)
	e1:SetTarget(nep.target3(ccode,loc,f,ctg,ext_params))
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	return e1
end
function nep.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nep.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function nep.cfilter(c)
	return nep.isnep(c) and c:IsFaceup()
end
function nep.efilter(c)
	return c:IsCode(ccode) and c:IsFaceup()
end
function nep.target3(ccode,loc,f,ctg,ext_params)
return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(loc) and f(chkc,table.unpack(ext_params)) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(f,tp,0,loc,1,nil,table.unpack(ext_params)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,f,tp,0,loc,1,1,nil,table.unpack(ext_params))
	Duel.SetOperationInfo(0,ctg,g,1,0,0)
	local p1,p2=e:GetProperty()
	if Duel.IsExistingMatchingCard(nep.efilter,tp,LOCATION_ONFIELD,0,1,nil,ccode) then
		p1=bit.bor(p1,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	else
		p1=p1-bit.band(p1,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	end
	e:SetProperty(p1,p2)
end
end