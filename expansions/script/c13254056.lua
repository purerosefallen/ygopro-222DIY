--以太飞球
function c13254056.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,13254052,aux.FilterBoolFunction(c13254056.ffilter),1,true,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c13254056.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c13254056.sprcon)
	e2:SetOperation(c13254056.sprop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13254056,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,13254056)
	e3:SetTarget(c13254056.target)
	e3:SetOperation(c13254056.activate)
	c:RegisterEffect(e3)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c13254056.target2)
	e4:SetOperation(c13254056.operation2)
	c:RegisterEffect(e4)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_CHANGE_LEVEL)
	e10:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	
end
function c13254056.ffilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsFusionType(TYPE_FUSION)
end
function c13254056.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end

function c13254056.cfilter(c)
	return (c:IsFusionCode(13254052) or (c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsFusionType(TYPE_FUSION)) and c:IsType(TYPE_MONSTER))
		and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c13254056.fcheck(c,sg)
	return c:IsFusionCode(13254052) and sg:IsExists(c13254056.fcheck2,1,c)
end
function c13254056.fcheck2(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsFusionType(TYPE_FUSION)
end
function c13254056.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=mg:IsExists(c13254056.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:IsExists(c13254056.fcheck,1,nil,sg)
	end
	sg:RemoveCard(c)
	return res
end
function c13254056.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c13254056.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c13254056.fselect,1,nil,tp,mg,sg)
end
function c13254056.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c13254056.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=mg:FilterSelect(tp,c13254056.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoGrave(sg,REASON_COST)
end
function c13254056.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x356) and c:IsAbleToHand()
end
function c13254056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254056.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13254056.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c13254056.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c13254056.filter1(c)
	return c:IsCode(13254031) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c13254056.filter2(c)
	return c:IsCode(13254056) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c13254056.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c13254056.filter1(chkc) and c13254056.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254056.filter1,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(c13254056.filter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c13254056.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c13254056.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c13254056.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
end
function c13254056.tgfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c13254056.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=2 then return end
	Duel.BreakEffect()
	local tg=Duel.GetMatchingGroup(c13254056.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if tg:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg2=tg:Select(tp,3,3,nil)
		Duel.SendtoDeck(tg2,nil,2,REASON_EFFECT)
	end
end
