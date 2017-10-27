--禁忌飞球·色欲
function c13254064.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,13254062,aux.FilterBoolFunction(c13254064.ffilter),1,true,false)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c13254064.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c13254064.sprcon)
	e2:SetOperation(c13254064.sprop)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c13254064.psplimit)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c13254064.cost)
	e4:SetTarget(c13254064.target)
	e4:SetOperation(c13254064.operation)
	c:RegisterEffect(e4)
	--Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(13254064,2))
	e5:SetCategory(CATEGORY_CONTROL+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,13254064)
	e5:SetTarget(c13254064.target2)
	e5:SetOperation(c13254064.operation2)
	c:RegisterEffect(e5)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(13254064,3))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,23254064)
	e6:SetTarget(c13254064.pentg)
	e6:SetOperation(c13254064.penop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_RELEASE)
	e7:SetCountLimit(1,33254064)
	e7:SetCost(c13254064.cost3)
	e7:SetTarget(c13254064.target3)
	e7:SetOperation(c13254064.operation3)
	c:RegisterEffect(e7)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_CHANGE_LEVEL)
	e10:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	
end
function c13254064.ffilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254064.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c13254064.cfilter(c)
	return (c:IsFusionCode(13254062) or (c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)) and c:IsType(TYPE_MONSTER))
		and c:IsCanBeFusionMaterial() and c:IsReleasable()
end
function c13254064.fcheck(c,sg)
	return c:IsFusionCode(13254062) and sg:IsExists(c13254064.fcheck2,1,c)
end
function c13254064.fcheck2(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254064.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=mg:IsExists(c13254064.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:IsExists(c13254064.fcheck,1,nil,sg)
	end
	sg:RemoveCard(c)
	return res
end
function c13254064.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c13254064.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c13254064.fselect,1,nil,tp,mg,sg)
end
function c13254064.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c13254064.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=mg:FilterSelect(tp,c13254064.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.Release(sg,REASON_COST)
end
function c13254064.psplimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c13254064.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c13254064.filter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsAbleToHand()
end
function c13254064.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and c13254064.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254064.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c13254064.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c13254064.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c13254064.filter1(c)
	return (c:IsCode(13254033) or c:IsCode(13254062)) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c13254064.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c13254064.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254064.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c13254064.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
end
function c13254064.cfilter(c)
	return c:IsControlerCanBeChanged()
end
function c13254064.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=1 then return end
	Duel.BreakEffect()
	local g1=Duel.GetMatchingGroup(c13254064.cfilter,tp,0,LOCATION_MZONE,nil)
	if g1:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=g1:Select(tp,1,1,nil)
	Duel.HintSelection(g2)
	Duel.GetControl(g2,tp)
end
function c13254064.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c13254064.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c13254064.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c13254064.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetMZoneCount(tp)>-1
			and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local p=(sg:GetFirst():GetControler())
	Duel.Release(sg,REASON_COST)
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,p,1)
end
function c13254064.operation3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

