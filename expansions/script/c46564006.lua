--黯 灭 的 伏 行 ·月 与 海
local m=46564006
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m) 
	--loven paly
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.vcon)
	e0:SetOperation(cm.loven)
	c:RegisterEffect(e0)
	--Special Summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(0x656)
	e3:SetCondition(cm.spcon)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.vcon(e)
	return bit.band(e:GetHandler():GetSummonType(),0x656)==0x656
end
function cm.loven(e,tp,eg)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,0))
end
function cm.tdfilter(c)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToDeckAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.thfilter(c,tp)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE,0,1,nil,c)
end
function cm.thfilter2(c,mc)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand() and cm.isfit(c,mc)
end
function cm.isfit(c,mc)
	return mc.fit_monster and c:IsCode(table.unpack(mc.fit_monster))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE,0,nil,g:GetFirst())
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			g:Merge(sg)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsControler(tp) and bit.band(a:GetType(),0x81)==0x81
end
function cm.upfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.upfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.upfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
