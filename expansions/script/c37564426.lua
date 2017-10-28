--百慕 理想的妹妹·梅娅
local m=37564426
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_prism=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Senya.setreg(c,m,37564573)
	Senya.PrismDamageCheckRegister(c,true)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+  EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564765,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(cm.destg)
	e7:SetOperation(cm.desop)
	c:RegisterEffect(e7)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(5)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCost(cm.cost)
	e3:SetCondition(Senya.PrismDamageCheckCondition)
	e3:SetOperation(Senya.PrismDamageCheckOperation)
	c:RegisterEffect(e3)
end
function cm.spfilter(c)
	return Senya.check_set_prism(c) and (c:IsAbleToHandAsCost() or c:IsAbleToExtraAsCost())
end
function cm.spgcheck(g,tp)
	return Duel.GetMZoneCount(tp,g,tp)>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE,0,nil)
	return Senya.CheckGroup(mg,cm.spgcheck,nil,3,3,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE,0,nil)
	local g=Senya.SelectGroup(tp,HINTMSG_RTOHAND,mg,cm.spgcheck,nil,3,3,tp)
	c:SetMaterial(g)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,63,nil)
	local ct=Duel.SendtoDeck(g,tp,0,REASON_COST)
	Duel.SortDecktop(tp,tp,ct)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if not Duel.IsPlayerCanDraw(tp) or ct==0 then return end
	for i=1,ct do
		local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		if g:GetCount()==0 then break end
		local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
		Duel.MoveSequence(tc,0)
	end
	local dct=ct-Duel.Draw(tp,ct,REASON_EFFECT)
	if dct>0 then
		local g=Duel.GetDecktopGroup(tp,dct)
		if g:GetCount()==0 then return end
		for tc in aux.Next(g) do
			Duel.MoveSequence(tc,1)
		end
	end
end
function cm.con(e)
	return (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler())
	and e:GetHandler():GetBattleTarget()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetBattleTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end