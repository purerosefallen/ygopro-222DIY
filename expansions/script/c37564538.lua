--Nanahira & Dazz
local m=37564538
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	c:EnableReviveLimit()
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e22:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e22)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(m)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	if not cm.chk then
		cm.chk=true
		cm.effect_list={}
		local ex=Effect.GlobalEffect()
		ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex:SetCode(EVENT_ADJUST)
		ex:SetOperation(cm.reg)
		Duel.RegisterEffect(ex,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.spfilter(c)
	return c.Senya_desc_with_nanahira and c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,3,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,3,3,nil)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.f(c)
	return c:GetSequence()<5 and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.add(tc)
	local p2=0
	if bit.band(tc:GetOriginalType(),TYPE_QUICKPLAY+TYPE_TRAP)==0 then p2=EFFECT_TYPE_QUICK_O end
	local e2=Effect.CreateEffect(tc)
	e2:SetDescription(m*16)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL,0)
	e2:SetType(EFFECT_TYPE_ACTIVATE+p2)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCost(cm.desccost)
	e2:SetCondition(cm.condition2)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	tc:RegisterEffect(e2)
	cm.effect_list[tc]=e2
end
function cm.desccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.rmv(tc)
	local e=cm.effect_list[tc]
	e:Reset()
	cm.effect_list[tc]=nil
end
function cm.reg(e,tp,eg,ep,ev,re,r,rp)
	local rg=Group.CreateGroup()
	for tc,te in pairs(cm.effect_list) do
		if tc and te then rg:AddCard(tc) end
	end
	for i=0,1 do
		local rg2=rg:Filter(Card.IsControler,nil,i)
		if Duel.IsPlayerAffectedByEffect(i,m) then
			rg2:ForEach(function(tc)
				if tc:IsLocation(LOCATION_SZONE) and cm.f(tc) then return end
				rg:RemoveCard(tc)
				cm.rmv(tc)
			end)
			local g=Duel.GetMatchingGroup(cm.f,i,LOCATION_SZONE,0,nil)
			g:Sub(rg)
			g:ForEach(cm.add)
		else
			rg2:ForEach(cm.rmv)
		end
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if e:GetHandler():GetTurnID()==Duel.GetTurnCount() and bit.band(e:GetHandler():GetOriginalType(),TYPE_QUICKPLAY+TYPE_TRAP)==0 then return false end
	local t1=bit.band(e:GetHandler():GetOriginalType(),0x7)
	local t2=bit.band(re:GetHandler():GetOriginalType(),0x7)
	return bit.band(t1,t2)~=0
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	if e:IsActiveType(TYPE_CONTINUOUS) and not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_PENDULUM) then return end
	local e1=nil
	if tc:IsType(TYPE_MONSTER) and not tc:IsHasEffect(EFFECT_MONSTER_SSET) then
		e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MONSTER_SSET)
		e1:SetReset(RESET_EVENT+0xfe0000)
		e1:SetValue(TYPE_SPELL)
		tc:RegisterEffect(e1)
	end 
	if tc:IsSSetable() then
		Duel.DisableShuffleCheck()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	elseif e1 then
		e1:Reset()
	end
end