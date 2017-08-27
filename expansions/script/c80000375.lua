--ＰＭ 雷电兽
function c80000375.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,80000374),aux.NonTuner(c80000375.synfilter),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--chain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c80000375.chop)
	c:RegisterEffect(e1)
	--chain
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetCode(EVENT_CHAINING)
	e10:SetRange(LOCATION_MZONE)
	e10:SetOperation(c80000375.chop3)
	c:RegisterEffect(e10)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000375,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,80000375)
	e2:SetCondition(c80000375.descon)
	e2:SetTarget(c80000375.destg)
	e2:SetOperation(c80000375.desop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000375,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,80000376)
	e3:SetCondition(c80000375.drcon)
	e3:SetTarget(c80000375.drtg)
	e3:SetOperation(c80000375.drop)
	e3:SetLabelObject(e10)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetCondition(c80000375.limcon)
	e4:SetValue(c80000375.limval)
	c:RegisterEffect(e4)  
	--chain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c80000375.chop1)
	c:RegisterEffect(e5)
	--atk
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EXTRA_ATTACK)
	e6:SetCondition(c80000375.atkcon)
	e6:SetValue(1)
	c:RegisterEffect(e6)  
end
function c80000375.synfilter(c)
	return c:IsSetCard(0x2d0) and c:IsRace(RACE_THUNDER)
end
function c80000375.chop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct==1 then
		e:SetLabel(0)
	elseif ct>=2 then
		e:SetLabel(1)
	end
end
function c80000375.chop3(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct==1 then
		e:SetLabel(0)
	elseif ct>=3 then
		e:SetLabel(1)
	end
end
function c80000375.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_THUNDER) and c:IsSetCard(0x2d0)
end
function c80000375.limcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80000375.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c80000375.limval(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsRace(RACE_THUNDER) and not rc:IsImmuneToEffect(e)
end
function c80000375.descon(e,tp,eg,ep,ev,re,r,rp)
	local res=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(0)
	return res==1
end
function c80000375.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c80000375.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c80000375.drcon(e,tp,eg,ep,ev,re,r,rp)
	local res=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(0)
	return res==1
end
function c80000375.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetChainLimit(aux.FALSE)
end
function c80000375.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c80000375.chop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()>1
		and e:GetHandler():GetFlagEffect(80000375)==0 then
		e:GetHandler():RegisterFlagEffect(80000375,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c80000375.atkcon(e)
	return e:GetHandler():GetFlagEffect(80000375)~=0
end