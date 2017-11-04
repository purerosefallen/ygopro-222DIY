--～Niko和世界记录仪～
--script by Nanahira
local m=11113135
local cm=_G["c"..m]
--local coroutine=require("coroutine")
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.Hint(11,0,m*16+1)
	end)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_BOTH_SIDE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.filter(c)
	local mt=getmetatable(c)
	return c:IsType(TYPE_EFFECT) and mt and mt.initial_effect
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetTargetPlayer(e:GetHandlerPlayer())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cp=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsControler(1-cp) or c:IsImmuneToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local original_register_effect=Card.RegisterEffect
	local original_set_range=Effect.SetRange
	local original_set_target_range=Effect.SetTargetRange
	Card.RegisterEffect=cm.replace_register_effect(original_register_effect,tp,cp)
	Effect.SetRange=cm.replace_set_range(original_set_range)
	if tp~=cp then
		Effect.SetTargetRange=cm.replace_set_target_range(original_set_target_range)
	end
	c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	Card.RegisterEffect=original_register_effect
	Effect.SetRange=original_set_range
	Effect.SetTargetRange=original_set_target_range
	tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetOwnerPlayer(tp)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetLabelObject(tc)
	e2:SetCondition(cm.descon)
	e2:SetOperation(cm.desop)
	Duel.RegisterEffect(e2,tp)
end
function cm.replace_set_range(f)
	return function(e,r)
		local tr=r
		if tr==LOCATION_MZONE then
			tr=LOCATION_FZONE
		end
		return f(e,tr)
	end
end
function cm.replace_set_target_range(f)
	return function(e,s,o)
		if e:GetCode()==EFFECT_SPSUMMON_PROC_G then
			return f(e,s,o)
		else
			return f(e,o,s)
		end
	end
end
function cm.player_check(con,cp)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return (not con or con(e,tp,eg,ep,ev,re,r,rp)) and tp==cp
	end
end
function cm.player_check_g(con,tp)
	return function(e,c,og)
		if not con then return true end
		local original_get_handler_player=Effect.GetHandlerPlayer
		local original_get_controler=Card.GetControler
		Effect.GetHandlerPlayer=function(te)
			if te==e then return tp end
			return original_get_handler_player(te)
		end
		Card.GetControler=function(tc)
			if tc==c then return tp end
			return original_get_controler(tc)
		end
		local res=con(e,c,og)
		Effect.GetHandlerPlayer=original_get_handler_player
		Card.GetControler=original_get_controler
		return res
	end
end
function cm.continuous_replace(f,p)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return not f or f(e,p,eg,ep,ev,re,r,rp)
	end
end
function cm.check_atk(f,ec,dval)
	return function(c,...)
		if c==ec then
			return dval
		end
		return f(c,...)
	end
end
function cm.replace_cost(cost)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if not cost then return true end
		if chk==0 then
			local c=e:GetHandler()
			local check_list={
				GetAttack=0,
				GetDefense=0,
				GetBaseAttack=0,
				GetBaseDefense=0,
				GetTextAttack=0,
				GetTextDefense=0,
				IsAttackAbove=false,
				IsAttackBelow=false,
				IsDefenseAbove=false,
				IsDefenseBelow=false,
			}
			local replace_list={}
			for fname,dval in pairs(check_list) do
				local f=Card[fname]
				Card[fname]=cm.check_atk(f,c,dval)
				replace_list[fname]=f
			end
			local ret=cost(e,tp,eg,ep,ev,re,r,rp,0)
			for fname,orif in pairs(replace_list) do
				Card[fname]=orif
			end
			return ret
		end
		cost(e,tp,eg,ep,ev,re,r,rp,1)
		if not c:IsLocation(LOCATION_SZONE) or c:GetSequence()~=5 then
			local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
			cm[cid]=true
		end
	end
end
function cm.replace_operation(op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
		if op and (cm[cid] or e:GetHandler():IsRelateToEffect(e)) then
			op(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function cm.replace_register_effect(f,tp,cp)
	return function(c,e,forced)
		if e:IsHasType(EFFECT_TYPE_FLIP+EFFECT_TYPE_EQUIP+EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_XMATERIAL) or e:GetCode()==EFFECT_SPSUMMON_PROC or e:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then return 0 end
		if tp~=cp and not e:IsHasProperty(EFFECT_FLAG_BOTH_SIDE) then
			local pr1,pr2=e:GetProperty()
			if e:IsHasType(0x7e0) then
				e:SetProperty(bit.bor(pr1,EFFECT_FLAG_BOTH_SIDE),pr2)
				e:SetCondition(cm.player_check(e:GetCondition(),tp))			
			elseif e:GetCode()==EFFECT_SPSUMMON_PROC_G then
				e:SetProperty(bit.bor(pr1,EFFECT_FLAG_BOTH_SIDE),pr2)
				e:SetCondition(cm.player_check_g(e:GetCondition(),tp))
			elseif e:IsHasType(EFFECT_TYPE_CONTINUOUS) then
				e:SetOwnerPlayer(tp)
				e:SetCondition(cm.continuous_replace(e:GetCondition(),tp))
				e:SetOperation(cm.continuous_replace(e:GetOperation(),tp))
			end
		end
		if e:IsHasType(0x7e0) then
			e:SetCost(cm.replace_cost(e:GetCost()))
			e:SetOperation(cm.replace_operation(e:GetOperation()))
		end
		return f(c,e,forced)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end