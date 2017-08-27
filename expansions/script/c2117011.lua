--ハーピィ・レディ・SB
local m=2117011
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,cm.mfilter,5,3,cm.ovfilter,aux.Stringid(m,2),3,cm.xyzop)
	c:EnableReviveLimit()
	--discard or return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.dcon)
	e2:SetTarget(cm.dtg)
	e2:SetOperation(cm.dop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.rmtg1)
	e3:SetOperation(cm.rmop1)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(m)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	if not cm.chk then
		cm.chk=true
		cm.card_list={}
		local ex=Effect.GlobalEffect()
		ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex:SetCode(EVENT_ADJUST)
		ex:SetOperation(cm.reg)
		Duel.RegisterEffect(ex,0)
	end
end
function cm.mfilter(c)
	return c:IsRace(RACE_FIEND) 
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21c) and c:IsXyzType(TYPE_XYZ)
end
function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,tp,1)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local sg=g:RandomSelect(tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
function cm.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.f(c)
	return c:GetSequence()<6 and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetActivateEffect()
end
function cm.add_effect(tc)
	local te=tc:GetActivateEffect()
	local ttg=te:GetTarget() or aux.TRUE
	te:SetTarget(aux.FALSE)
	local e2=Effect.CreateEffect(tc)
	e2:SetDescription(m*16)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.desccost)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	tc:RegisterEffect(e2,true)
	cm.card_list[tc]={gain_effect=e2,original_effect=te,original_target=ttg}
end
function cm.desccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.reset_effect(tc)
	local e=cm.card_list[tc].gain_effect
	local te=cm.card_list[tc].original_effect
	local ttg=cm.card_list[tc].original_target
	e:Reset()
	te:SetTarget(ttg)
	cm.card_list[tc]=nil
end
function cm.reg(e,tp,eg,ep,ev,re,r,rp)
	local rg=Group.CreateGroup()
	for tc,t in pairs(cm.card_list) do
		if tc and t then rg:AddCard(tc) end
	end
	for i=0,1 do
		local rg2=rg:Filter(Card.IsControler,nil,i)
		if Duel.IsPlayerAffectedByEffect(i,m) then
			rg2:ForEach(function(tc)
				if tc:IsLocation(LOCATION_SZONE) and cm.f(tc) then return end
				rg:RemoveCard(tc)
				cm.reset_effect(tc)
			end)
			local g=Duel.GetMatchingGroup(cm.f,i,LOCATION_SZONE,0,nil)
			g:Sub(rg)
			g:ForEach(cm.add_effect)
		else
			rg2:ForEach(cm.reset_effect)
		end
	end
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(e:GetActiveType(),TYPE_CONTINUOUS+TYPE_FIELD)~=0 and not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(e:GetActiveType(),TYPE_CONTINUOUS+TYPE_FIELD)~=0 and not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end