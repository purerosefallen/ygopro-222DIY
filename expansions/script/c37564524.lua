local m=37564524
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.AddXyzProcedureCustom(c,cm.mfilter,Senya.GroupFilterMulti(table.unpack(cm.flist)),4,4)
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e22:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e22)
	Senya.Nanahira(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	Senya.CopySpellModule(c,LOCATION_DECK+LOCATION_GRAVE,0,cm.check_nnhr,nil,nil,1,EFFECT_COUNT_CODE_SINGLE,nil,false)
end
if Senya.master_rule_3_flag then
	cm.flist={
		aux.FilterBoolFunction(Card.IsXyzType,TYPE_FUSION),
		aux.FilterBoolFunction(Card.IsXyzType,TYPE_SYNCHRO),
		aux.FilterBoolFunction(Card.IsXyzType,TYPE_XYZ),
		aux.FilterBoolFunction(Card.IsXyzType,TYPE_RITUAL),
	}

else
	cm.flist={
		aux.FilterBoolFunction(Card.IsXyzType,TYPE_FUSION),
		aux.FilterBoolFunction(Card.IsXyzType,TYPE_SYNCHRO),
		aux.FilterBoolFunction(Card.IsXyzType,TYPE_XYZ),
		aux.FilterBoolFunction(Card.IsXyzType,TYPE_LINK),
	}
end
function cm.check_nnhr(c)
	return c.Senya_desc_with_nanahira
end
function cm.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and c:IsCode(37564765) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function cm.rmfilter(c)
	return c:IsAbleToRemove()
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local gc=g:Select(tp,1,1,nil):GetFirst()
	Duel.Remove(gc,POS_FACEUP,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc then
			local cd=tc:GetOriginalCode()
			Senya.CopyEffectExtraCount(c,7,cd,RESET_EVENT+0x1fe0000,1)
		end
end